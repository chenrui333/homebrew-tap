class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "6ce823a1780668b965ee9054f519acb039159e7f887496900f5a8719c4a16ebb"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "cd9513dc3bf5bef9930cb44fc163a4e2a5005029a338511483e8ff580133206f"
    sha256                               arm64_sequoia: "00beb5bb7b6b0a8503dbc6ff3c92599ffafd400ca2ada2bfabe6c11efcab6e2d"
    sha256                               arm64_sonoma:  "2baac0a4b275988ff365534a0c1490f207364b38fd686b06114e2fe76209adb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbe922a6a71504404e79b96a46acea1a5e56f232ea727971485b865bb62d1eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cefd803629957f322bd3bac58bbd15f33ccceb9474a5d229ce5d4e93eefd72b"
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
