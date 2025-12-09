class Pysentation < Formula
  include Language::Python::Virtualenv

  desc "TUI for displaying Python presentations"
  homepage "https://github.com/mimseyedi/pysentation"
  url "https://files.pythonhosted.org/packages/51/51/ec0508b25edd1d91707b835035195676708d1d03ef80518ea32cfa1b42b9/pysentation-1.0.0.tar.gz"
  sha256 "996b2d8569e4fbf9376b73e695ffb8133cbbf1a37a146c7f396e4dd53245a8d0"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "f69553984a691495d2fa02dc6be75c2cfa703ec817f8e47c1d8a63651ce1e418"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "getkey" do
    url "https://files.pythonhosted.org/packages/74/f2/3312ea94369f410967667eeca61d261cdf3037df6ea827078ac7c5321150/getkey-0.6.5.tar.gz"
    sha256 "68c7c702c3b34deacf427f6c0f1fd66c5c2aa12d7801aa32442fc1a71c8ce059"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/02/97/0046b5e3c6a5057b5817e5e6c51a776d410b953e6a9c67ae249dafdd2999/rich-13.4.1.tar.gz"
    sha256 "76f6b65ea7e5c5d924ba80e322231d7cb5b5981aa60bfc1e694f1bc097fe6fe1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pysentation --version")
  end
end
