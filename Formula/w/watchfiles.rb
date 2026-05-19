class Watchfiles < Formula
  include Language::Python::Virtualenv

  desc "Simple, modern and high performance file watching and code reload in python"
  homepage "https://watchfiles.helpmanual.io/"
  url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
  sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f2559a5937d722b43931a2078cf4fe52a8541d0b2a484851c27b1730e96cf531"
    sha256 cellar: :any,                 arm64_sequoia: "373fefec69666aaf9ff9abb2944985848e0f7b5446cbc44b100579e575246cee"
    sha256 cellar: :any,                 arm64_sonoma:  "d0ea651458ac91bfaf16b7808d3c3ba5302151f8eb9b1bfd899bce2c2ea1fc1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a98ca740fb32279f60cf6d95cbab7a194ffe802d6de1d4ba607bb5e17a892426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "241a9c9a633e0a83ff45688d0aa227b1a873c74872d7e9061ba86c1b3f94c220"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watchfiles --version")
  end
end
