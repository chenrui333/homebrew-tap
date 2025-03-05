class Foy < Formula
  desc "Simple, light-weight and modern task runner for general purpose"
  homepage "https://zaaack.github.io/foy/"
  url "https://registry.npmjs.org/foy/-/foy-0.2.43.tgz"
  sha256 "e5332890ed1e7eb770d2bd39795db8b12e39b08e303eb6da15feb2b719776ea2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e95c44aea42e4144b898b0ed2f2d8dd2f2491ce2260eaee1173bc0923d6eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b990d7d29ec7bda2eafcadb30d2ed834c896f0dc882d6393745390fe28c707a9"
    sha256 cellar: :any_skip_relocation, ventura:       "abdc4da801af762a0791b8314e32082a09d3e24d73cd7ea56339eb8bc4effc3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440988ee8a0cee42fb6f25cec6bb9934ae79a36d9d565bb7d8ae55b7fabb8ecd"
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
