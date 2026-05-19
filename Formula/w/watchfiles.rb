class Watchfiles < Formula
  include Language::Python::Virtualenv

  desc "Simple, modern and high performance file watching and code reload in python"
  homepage "https://watchfiles.helpmanual.io/"
  url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
  sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "53b14a2f1e98dad723f9cd681c49ca86db85d805327c1b9793d5db54d51c3720"
    sha256 cellar: :any,                 arm64_sequoia: "49d99781c2e9e1a70ee9ffb5b3f064143e233038ee6f0a73c1db7aec08c3d0a7"
    sha256 cellar: :any,                 arm64_sonoma:  "9c1baf8ff00510999869aea5b16f6454ddd0ce7c87ae8534acee8b7d299d53c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2180dd6fee0f2ffd0464aa81bbc05a8c5204fe2ead219c9074de37a543746bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "706622176181a171f32a1615fe0ee5a0ee0434d22edb5989a034096c54b61a3a"
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
