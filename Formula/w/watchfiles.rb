class Watchfiles < Formula
  include Language::Python::Virtualenv

  desc "Simple, modern and high performance file watching and code reload in python"
  homepage "https://watchfiles.helpmanual.io/"
  url "https://files.pythonhosted.org/packages/b3/68/e6aa0b77d217b31f8f486ec0cdfe5e00e6e38dc0be657e7d85819b9faf0a/watchfiles-1.3.0.tar.gz"
  sha256 "99aee4a07847c06820765fd7b1b49ceac4f3f711ccb7d104655a33231de1c207"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "518aaa0eae0ac3d02c0b7b45776c31941ffa3a0c745df3ccc2006e1f265e8304"
    sha256 cellar: :any, arm64_sequoia: "ac6f7b0315aef110dc2caba7352337b7257e411b2118433223953dc9b6397f34"
    sha256 cellar: :any, arm64_linux:   "5ce97cff09a218c5f2cdda69ddb0c432dec5a8e6d6158cbc9fe8a7f754076cb3"
    sha256 cellar: :any, x86_64_linux:  "b931a835561ae757845243decc827b292c1f755ac34cf8a9c055fd95885e5c1b"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watchfiles --version")

    output = shell_output("#{bin}/watchfiles true #{testpath}/missing 2>&1", 1)
    assert_match "does not exist", output
  end
end
