class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "2e8ff694898afceb93ff595a930769ba23185512350da1901503366c7d527c79"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "6e3b10984f0aac4932a35484270495dac4e32424aeb126017afbcd99cc40826a"
    sha256                               arm64_sequoia: "067f042a535d023cd76deddf086a8dcab3c32f9acba3f8b94c80c8e97fa4984c"
    sha256                               arm64_sonoma:  "5d447070c9475a7bbf902bec6832c56c589f980ffba4ee81aff811abfc372f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2be18981f6d5f1141caf1ea2437f44e1a3793415c85985aab40d4e3876f74217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e891a7203267f3f31b3555c5d666995ea902b15de34c12f89419c14d2fb76a6c"
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
