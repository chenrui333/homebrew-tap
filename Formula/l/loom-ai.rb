class LoomAi < Formula
  desc "Loop engineering for agentic software delivery"
  homepage "https://github.com/valkor-ai/loom"
  url "https://github.com/valkor-ai/loom/archive/50c758a6cea097afb94570498540f3200a295120.tar.gz"
  version "0.1.0"
  sha256 "37644525db2dd648ba8b695a8634b7ad7e1f08b1eb26e76f92327c2932c6a772"
  license "Apache-2.0"
  head "https://github.com/valkor-ai/loom.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "ci"
    system "npm", "run", "build"
    system "npm", "pack"
    system "npm", "install", *std_npm_args, "loom-#{version}.tgz"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/loom --version")
    assert_match "loom", shell_output("#{bin}/loom --help")
  end
end
