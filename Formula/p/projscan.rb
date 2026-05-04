class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "9972b9c92c7888cc3d111b5d099c8438849a09d9c94a6aefbd8c28bbfb9d030d"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "07b494df1f45243542a19676ec528baf366e05cd7ed166276945a0065fbfc382"
    sha256                               arm64_sequoia: "d7b5ad076f38ea64a479dcd1c4119de26aad49aa4bd30618d6c86bc212dabb82"
    sha256                               arm64_sonoma:  "89c8704f7fdf07db70f35f3bdb49ef19c5f588aa33a80193d6626a2b9a2d92f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa79781c6c210f5be00f73f4ecda126557722134e84a26ab984a110633b4be70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e957fece468dd84358f7234c5ff1ab0c06b838e99af7fd7bbe8f68aacc0690f"
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
