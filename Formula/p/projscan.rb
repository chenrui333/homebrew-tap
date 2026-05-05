class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "2e8ff694898afceb93ff595a930769ba23185512350da1901503366c7d527c79"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f03bcc1edd73c251def50c24f85088606e2b065b0daefe6b20100fa18b8f1fa5"
    sha256                               arm64_sequoia: "133eaed0dee1e21a882672abc51765a6ca1ae71eaa99460e6fadd7bf112e7c6b"
    sha256                               arm64_sonoma:  "cf72bcbc7e3d9c2dd20975147ab2d6a5d6a3abaaacf46373d5cd8ed650676bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a0f9c889b00f16a7a787f7eb4e1ae04bf25a1859949ac0ff0ebe72c4f6870bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d830236102a6a7db2f285ecfe0dd7e671eea4463b4642be34bedd0d9ae2e8590"
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
