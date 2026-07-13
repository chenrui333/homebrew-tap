class Foy < Formula
  desc "Simple, light-weight and modern task runner for general purpose"
  homepage "https://zaaack.github.io/foy/"
  url "https://registry.npmjs.org/foy/-/foy-1.1.2.tgz"
  sha256 "8b854045bec7b46a01c8db3cbe54ae502056f0f714e35f22efe20b0a2f118661"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "be012ef2e289e6bed144bb69ee00e186898789173ac65efedfc5ac3c0ef92a36"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
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
      import { writeFile } from "node:fs/promises"

      task("hello", async () => {
        await writeFile("result.txt", "done")
        console.log('Hello, world!')
      })
    JS

    assert_match "Hello, world!", shell_output("#{bin}/foy hello")
    assert_equal "done", (testpath/"result.txt").read
  end
end
