class Foy < Formula
  desc "Simple, light-weight and modern task runner for general purpose"
  homepage "https://zaaack.github.io/foy/"
  url "https://registry.npmjs.org/foy/-/foy-0.2.43.tgz"
  sha256 "e5332890ed1e7eb770d2bd39795db8b12e39b08e303eb6da15feb2b719776ea2"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
