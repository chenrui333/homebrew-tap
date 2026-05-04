class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b260052001e67bf7017a0b2d047c0b6f1f98b6ff301e8aacb33d87d9a1e04ee1"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "02b916d8fc14797a6b50712e92e1c80446e7b6c97afba3686fd16e36093e1a83"
    sha256                               arm64_sequoia: "dff0f1bdd98ca8960fc11f31a3690c41529f861189dd5f49f2e3aff065c210ed"
    sha256                               arm64_sonoma:  "39adb0744938010e41eaeafc99df2dc52d31d072a2541bd7fe7d1eb4dc6988e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2368e05939bbd768508ea6a0edb1b590641f73a83c0897fd6654bb59d75750b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "663f82420a3ac6b7b102de4762c3980dd6e8c78b1b78ef6edacabed5a03c2d0f"
  end

  depends_on "pkgconf" => :build
  depends_on "node"
  depends_on "vips"

  def install
    # Use Homebrew's Node headers instead of letting node-gyp fetch them during builds.
    ENV["npm_config_nodedir"] = Formula["node"].opt_prefix
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "install", "--include=dev", *std_npm_args(prefix: false, ignore_scripts: false)
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
