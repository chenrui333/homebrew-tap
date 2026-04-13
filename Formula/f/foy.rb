class Foy < Formula
  desc "Simple, light-weight and modern task runner for general purpose"
  homepage "https://zaaack.github.io/foy/"
  url "https://registry.npmjs.org/foy/-/foy-1.0.1.tgz"
  sha256 "cbeb9511db1d1aa35c27e3db281637fa70d41065c65579bbc179eaacce351e46"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "da3c3a790feffbbed6012fde61d54a5f68792fee81f48c163e3365928968e867"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test",
        "version": "1.0.0",
        "type": "module"
      }
    JSON

    (testpath/"node_modules").mkpath
    ln_s libexec/"lib/node_modules/foy", testpath/"node_modules/foy"

    (testpath/"Foyfile.js").write <<~JS
      import { task } from "foy"

      task("hello", async () => {
        console.log('Hello, world!')
      })
    JS

    assert_match "Hello, world!", shell_output("#{bin}/foy hello")
  end
end
