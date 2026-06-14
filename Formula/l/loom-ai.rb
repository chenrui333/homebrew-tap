class LoomAi < Formula
  desc "Loop engineering for agentic software delivery"
  homepage "https://github.com/valkor-ai/loom"
  url "https://github.com/valkor-ai/loom/archive/50c758a6cea097afb94570498540f3200a295120.tar.gz"
  version "0.1.0"
  sha256 "37644525db2dd648ba8b695a8634b7ad7e1f08b1eb26e76f92327c2932c6a772"
  license "Apache-2.0"
  head "https://github.com/valkor-ai/loom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "db8b729b42c4b10233d88ee61dd7a92e578b304389fd8d32f5a6debb14935da3"
    sha256 cellar: :any,                 arm64_sequoia: "f52857b068f00557d0f2a6d12cd933d8e0ec2067414cb57adc43104dcbcf7948"
    sha256 cellar: :any,                 arm64_sonoma:  "f52857b068f00557d0f2a6d12cd933d8e0ec2067414cb57adc43104dcbcf7948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c2300b760b943abeedd95cfde0b683bb5e624ace863d135fa5c956bb7157f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8122a14cc598ad04cec1348d91e7d6a268c0ca9a8f342ec95f2ece2519141871"
  end

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
