class Sudocode < Formula
  desc "Git-native spec and issue management for AI-assisted development"
  homepage "https://github.com/sudocode-ai/sudocode"
  url "https://registry.npmjs.org/sudocode/-/sudocode-1.2.0.tgz"
  sha256 "aa850176a5e51fb92de52a97048bf4526f23d1760595951c20179ad341faee8b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256               arm64_tahoe:   "2a022cb1a26ca7b02a0d738a6607a66577f26e5ea9028ba8793b82e2e6249d1e"
    sha256               arm64_sequoia: "1fa25035125bf9974c043276a24bbe16be9044b87fd2d1adc1f5b12bce999df7"
    sha256 cellar: :any, arm64_linux:   "3716a5b6be3c9804733be8099eb36a04dd6f1b23dd5edf495612c8b971fcc954"
    sha256 cellar: :any, x86_64_linux:  "241fbfcf86b9107d1f2806c58aed9a614b9fbac6d700b3a1d9da580218cbc496"
  end

  depends_on "pkgconf" => :build
  depends_on "node@24"
  depends_on "ripgrep"
  depends_on "vips"

  deny_network_access!

  def fetch
    ENV.prepend_path "PATH", formula_opt_bin("node@24")
    ENV.prepend_path "PATH", formula_opt_libexec("node@24")/"bin"
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    node_path = "#{formula_opt_bin("node@24")}:#{formula_opt_libexec("node@24")/"bin"}:" \
                "#{formula_opt_bin("ripgrep")}:$PATH"

    ENV.prepend_path "PATH", formula_opt_bin("node@24")
    ENV.prepend_path "PATH", formula_opt_libexec("node@24")/"bin"
    ENV["npm_config_nodedir"] = formula_opt_prefix("node@24")
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args(ignore_scripts: false)

    # Align CLI sub-package version with meta-package version
    cli_pkg = libexec/"lib/node_modules/sudocode/node_modules/@sudocode-ai/cli/package.json"
    inreplace cli_pkg, /"version": ".*?"/, "\"version\": \"#{version}\""

    # Remove prebuilds for non-native architectures
    nm = libexec/"lib/node_modules/sudocode/node_modules"
    if Hardware::CPU.arm?
      nm.glob("**/prebuilds/darwin-x64").each(&:rmtree)
      nm.glob("**/ripgrep/x64-darwin").each(&:rmtree)
    else
      nm.glob("**/prebuilds/darwin-arm64").each(&:rmtree)
      nm.glob("**/ripgrep/arm64-darwin").each(&:rmtree)
    end
    nm.glob("**/@anthropic-ai/claude-agent-sdk/vendor/ripgrep").each(&:rmtree)
    nm.glob("**/@zed-industries/codex-acp-linux-*").each(&:rmtree)
    nm.glob("**/@img/sharp-*").each(&:rmtree)

    libexec.glob("bin/*").each do |path|
      (bin/path.basename).write_env_script path, PATH: node_path, USE_BUILTIN_RIPGREP: "1"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sudocode --version")
  end
end
