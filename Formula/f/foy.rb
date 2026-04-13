class Foy < Formula
  desc "Simple, light-weight and modern task runner for general purpose"
  homepage "https://zaaack.github.io/foy/"
  url "https://registry.npmjs.org/foy/-/foy-1.0.0.tgz"
  sha256 "aeb22884699934f0f3de4517dedb57e8ce3fd08260b4c38542ab3c2065e6ddac"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "586a26cc31aca9a96b584ad4cd3845400d41b54c79cbf6684a548baedb33177a"
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
