class Watchfiles < Formula
  include Language::Python::Virtualenv

  desc "Simple, modern and high performance file watching and code reload in python"
  homepage "https://watchfiles.helpmanual.io/"
  url "https://files.pythonhosted.org/packages/2a/9a/d451fcc97d029f5812e898fd30a53fd8c15c7bbd058fd75cfc6beb9bd761/watchfiles-1.1.0.tar.gz"
  sha256 "693ed7ec72cbfcee399e92c895362b6e66d63dac6b91e2c11ae03d10d503e575"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "2447bc526e88c6281333bb111861b6668d821aeea1d2f2149c840ecb99b1502a"
    sha256 cellar: :any,                 arm64_sonoma:  "82bc5a475ef68ae6bf0f5ac5bfd6caaf9eaac19f6c4774101a0ed1d9a99b8cdb"
    sha256 cellar: :any,                 ventura:       "938fb336fd9f4ca7dba04b24cc1a471ec600fa70ace22a705f103afbd19e3647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638902d5155dafc9b89ce2e14431de670061a3379f02d5210b37259cb9b1b585"
  end

  depends_on "rust" => :build
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f1/b4/636b3b65173d3ce9a38ef5f0522789614e590dab6a8d505340a4efe4c567/anyio-4.10.0.tar.gz"
    sha256 "3f3fae35c96039744587aa5b8371e7e8e603c0702999535961dd336026973ba6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watchfiles --version")
  end
end
