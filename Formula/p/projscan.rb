class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "5c7fa04d9852b98a748335be52ad9b4222be2750b6e1bb04be698d62ea904630"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "02767f7dc970cc2bd233945a32409883a8d3b78ae6bfa8dd4cdc7182303526ab"
    sha256                               arm64_sequoia: "b5be9d5c47acfe700c1f060b23c094cb34923732f3e605562926db7a869482b7"
    sha256                               arm64_sonoma:  "d9ee208b1664eca614585e4d0e89bc7a65e0c1ec0a7065d989ec0345c043af8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed6da2b46c3f96e7d809fe2f179d48e818eeaa90bcca375c416c9e3d95b0d52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c78497d876bca87fe02b0b6fac0afe55fbfa60a7664ba9cae6bf5659f651be5"
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
