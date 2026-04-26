class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "7b4a8b0a2b9fafdeb9d5b8b2ce5c6891fb0b4676f243616e0fa419ce8fa3551f"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "e4bc3fe2352855ee7d6861d067be2ffab0fe9384134badf1bc7ad54f021bc462"
    sha256                               arm64_sequoia: "d69ad7c241744c7f669520596ff7d5887b2117ed5edc1e37429a8a4016b000e3"
    sha256                               arm64_sonoma:  "dfba1ebf31d19c86389b5cdaa79ba2ae98fbd2e36a48a635dbcf893dfbf0038a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "375f5d514a50f57649813c0df83b4508f3f42216c975fc3de547acc7d5dfec4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47563027d5944ca55c14027aac987077bf7faf161539f39d6ac0276db2511e1"
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
