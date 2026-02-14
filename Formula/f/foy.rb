class Foy < Formula
  desc "Simple, light-weight and modern task runner for general purpose"
  homepage "https://zaaack.github.io/foy/"
  url "https://registry.npmjs.org/foy/-/foy-0.3.0.tgz"
  sha256 "275c7e3a8f4a9243dc7d32bbfca008a2f87c0517a6e2bd8b0db9647a5ba5a914"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "048ef2bb88b689f6eed4b1b86d61fff7f0e7f76492d1e92ad7fa9a6511b7c288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50d41e8f6a254d8c11bdd616408f4e903eaef44e1204d0781417702041e4ae60"
    sha256 cellar: :any_skip_relocation, ventura:       "491605b0fce3c12c7827b778e4c45200b0bcec147f704f1003688003281b6e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1dbb1d34bbb1399db473f86e83dfccaf54f654b773023ff2cb6ab231f76806"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # see test failure in https://github.com/chenrui333/homebrew-tap/pull/485#issuecomment-2701902017
    ENV.prepend_path "NODE_PATH", libexec/"lib/node_modules"

    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "main": "index.js",
        "dependencies": {
          "foy": "#{version}"
        }
      }
    JSON

    (testpath/"Foyfile.js").write <<~JS
      const { task } = require('foy')
      task('hello', async ctx => {
        console.log('Hello, world!')
      })
    JS

    assert_match "Hello, world!", shell_output("#{bin}/foy hello")
  end
end
