class Foy < Formula
  desc "Simple, light-weight and modern task runner for general purpose"
  homepage "https://zaaack.github.io/foy/"
  url "https://registry.npmjs.org/foy/-/foy-0.2.44.tgz"
  sha256 "64f8bb39a0156f052a3dfb90ae75ba16b1ee2f14548d0932811049c5d46d5a69"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d391fad8c5db931724b0b8750da19745a06c069a55e69d9223a44eee7a7b0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98dfb6102b30cb16bb82982a3f92f59d4466279c3926f88fd505a332304bfa61"
    sha256 cellar: :any_skip_relocation, ventura:       "e725aafe60cf7758a0ad056e4a839011be1d6a77122ac9169e69612f166d9937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfe2dd2f7d5fee0f1134ede24c15bcba6f7a2e07dd6f9efcdf0878bdc464f410"
  end

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
