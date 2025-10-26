class Brotab < Formula
  include Language::Python::Virtualenv

  desc "Control your browser's tabs from the command-line"
  homepage "https://github.com/balta2ar/brotab"
  url "https://files.pythonhosted.org/packages/8f/1f/e5adafe088d99e7ed6883c94afda13a60cb056539d1f74a7f2ec42cce3c0/brotab-1.5.0.tar.gz"
  sha256 "2c307f2b13089bc560733df19ca546f3ac0c6613d69bd239b18f7ae164c18d55"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d975d00f78d3888b3e4c6b164059d8c2ab271c59bb5e3c6c7472a02e565f0b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30b5b5e9eb36b3567f7b530c4a4d898202ebb9e523474192418ff28ca5c78300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ab510984becaef3d95f2173b2acc294013fda5ec9c0107a4f391efb6d47ccb1"
    sha256 cellar: :any_skip_relocation, sequoia:       "752d676f1799b58e515d9fefb6e11b8768991735797ffefc543e6ca85d228201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aafb3eed31a6637781100412a13134673caaa5c20010c4c2d613f2d7ec59c07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d21cd1cbb0e799657bd6102ce7d03e2f71fabfc1d781524c8d73e78ba3ecf29"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/69/b6/53cfa30eed5aa7343daff36622843688ba8c6fe9829bb2b92e193ab1163f/Flask-2.2.2.tar.gz"
    sha256 "642c450d19c4ad482f96729bd2a8f6d32554aa1e231f4f6b4e7e5264b16cca2b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/3d/4b/d746f1000782c89d6c97df9df43ba8f4d126038608843d3560ae88d201b5/werkzeug-2.3.8.tar.gz"
    sha256 "554b257c74bbeb7a0d254160a4f8ffe185243f52a52035060b761ca62d977f03"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # there is no version output
    system bin/"brotab", "--help"

    system bin/"brotab", "text"
  end
end
