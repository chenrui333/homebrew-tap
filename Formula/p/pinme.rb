class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-1.2.5.tgz"
  sha256 "5aedd569286309160af59cb524ef9c79b2bef72cf0432365f4a7809211437679"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "c457e5584e5b822e995d96b7fffc6d0e8f9a0d27aa288d8b00a57c4910e87f33"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinme --version")
    assert_match "Failed to fetch domains: Auth not set", shell_output("#{bin}/pinme domain")
    assert_match "No upload history found", shell_output("#{bin}/pinme ls")
  end
end
