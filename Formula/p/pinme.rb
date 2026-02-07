class Pinme < Formula
  desc "Deploy Your Frontend in a Single Command"
  homepage "https://pinme.eth.limo/"
  url "https://registry.npmjs.org/pinme/-/pinme-1.2.3.tgz"
  sha256 "f31e7dc8509a95b76fd2c713680b8216622e8bcd3bd6d7beb0aafc10af30aa75"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ec3d0929dbae4332237e05f3c404d6afef1a8893f1bffd821ba7e5e673bd23f8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinme --version")
    assert_match "Failed to fetch domains: Auth not set", shell_output("#{bin}/pinme domain")
    assert_match "No upload history found", shell_output("#{bin}/pinme ls")
  end
end
