class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "df43bc19d39821dfb9a938010d1e2f0344d3dfab078bd109f9f64b426c80a48a"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b874385b8455aed3fbd8a03e82214af5b5c8021008108ca88a9fe8040087b70f"
    sha256                               arm64_sequoia: "4b4c5757d1e46557f16d94f027c1915dbf97872ba4c48bd34805c09aa839e324"
    sha256                               arm64_sonoma:  "bd3fe6ae0831f73a0e75a8014fd3b50d03829cb381c3240d1a9ac7d9753891f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1b386ac8387319c94ed7adbff952415449296b43539d54644a9425daf721df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f446f5818a68d1cefeb07c60e486340f06d44d91ba6c91e69f286fa1d23154fc"
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
