class Sudocode < Formula
  desc "Git-native spec and issue management for AI-assisted development"
  homepage "https://github.com/sudocode-ai/sudocode"
  url "https://registry.npmjs.org/sudocode/-/sudocode-1.2.0.tgz"
  sha256 "aa850176a5e51fb92de52a97048bf4526f23d1760595951c20179ad341faee8b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a22621f95a294b59de7fb73f50c2e413c2115f1a3ebb3d5fb5016afbf199d747"
    sha256                               arm64_sequoia: "8ec91d984d6c583b1025c9ae2d1dc99a8a20581fd5d5b22f8465a3de2374549b"
    sha256                               arm64_sonoma:  "43cf4e3f1e37099f8072105914544b44d5d60eea2a2e1e9fc7dbbfbdfa44e099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c73de68e8b7ddeebf36d8a43fe831b3545059c132d81badacd08937972a75bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d01fbe40ae6c34ff902c6ecb1d39377784553a81001703f84083dff4607c8126"
  end

  depends_on "pkgconf" => :build
  depends_on "node@24"
  depends_on "ripgrep"
  depends_on "vips"

  def install
    node_path = "#{Formula["node@24"].opt_bin}:#{Formula["node@24"].opt_libexec/"bin"}:" \
                "#{Formula["ripgrep"].opt_bin}:$PATH"

    ENV.prepend_path "PATH", Formula["node@24"].opt_bin
    ENV.prepend_path "PATH", Formula["node@24"].opt_libexec/"bin"
    ENV["npm_config_nodedir"] = Formula["node@24"].opt_prefix
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "install", *std_npm_args(ignore_scripts: false)

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
