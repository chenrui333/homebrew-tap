class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "28da7d0a4c31bd77987edced6d95f4c9b39575723658e1a10e6010d02fe9a871"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a4e8cf4fc094d6fcb921a9d7dafcc987b329e3ac99fdd12a5cd104a61e433917"
    sha256                               arm64_sequoia: "a3dff5ac27006c0d85e3f51e69a74e599f776419c4bc4e800a919ee5d0295bb9"
    sha256                               arm64_sonoma:  "6a3039643d101c25f72f266ebfc044f67c283c767a5e2191b67be05b8207b2b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03bf71d9aa6669cff4248ccda3f0653ec16a219dc818984807ea805f143e3db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4338a6f6d385b509eb4647a31cd4373fef3440c37a413180b5083f84224fedf"
  end

  depends_on "pkgconf" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "node"
  depends_on "vips"

  def install
    # Use Homebrew's Node headers instead of letting node-gyp fetch them during builds.
    ENV["npm_config_nodedir"] = Formula["node"].opt_prefix
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "pkg", "delete", "scripts.prepare"
    system "npm", "install", "--include=dev", *std_npm_args(prefix: false, ignore_scripts: false)

    tree_sitter_cli = buildpath/"node_modules/tree-sitter-cli/tree-sitter"
    rm tree_sitter_cli
    ln_sf Formula["tree-sitter-cli"].opt_bin/"tree-sitter", tree_sitter_cli

    system "npm", "run", "build"
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/projscan/node_modules"
    cd libexec/"lib/node_modules/projscan" do
      system "npm", "rebuild", "tree-sitter-go", "tree-sitter-java",
             "tree-sitter-python", "tree-sitter-ruby", "--build-from-source"
    end
    rm_r node_modules.glob("tree-sitter-*/prebuilds")

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/projscan --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "projscan-test",
        "version": "1.0.0"
      }
    JSON
    (testpath/"src").mkpath
    (testpath/"src/index.js").write "console.log('hello');\n"

    output = shell_output("cd #{testpath} && #{bin}/projscan doctor --format json")
    assert_match "\"health\"", output
    assert_match "\"score\"", output
  end
end
