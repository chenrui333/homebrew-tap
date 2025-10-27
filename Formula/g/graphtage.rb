class Graphtage < Formula
  include Language::Python::Virtualenv

  desc "Semantic diff utility for tree-like files such as JSON/JSON5/XML/HTML/YAML/CSV"
  homepage "https://github.com/trailofbits/graphtage"
  url "https://files.pythonhosted.org/packages/f3/51/46ae661912683e99f33fb4245a68e97a2fa8bc1e800ea65c983654028278/graphtage-0.3.1.tar.gz"
  sha256 "8650d1ca566f9ab4dbbd340c159131ce611f318f41014af47eaaac801e021d3b"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1acbf3be56ca1669c6468a1c4b7ba1a7f23aa76b330defc02146ada8065b042d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de65c5ec5cbc10b4d0ed62755dc80f91406cc792ced2c0f6bcb99074c580e6eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d2673ae17f0e14ca7cefac801a789cfd23378ad7c9e313b9f9ff34ae407069a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "503a28d204b0e5c9b0cfafd0e8059d962e35ae8fdfcc5f0db56cb00e7c6a0c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87eeed55ee1c6473eda6fe96c7e4e085174022efa2b22c8cbffaeedbe07ae684"
  end

  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python-setuptools" # for distutils
  depends_on "python@3.14"
  depends_on "scipy"

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/f3/af/4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029/astunparse-1.6.3.tar.gz"
    sha256 "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "fickling" do
    url "https://files.pythonhosted.org/packages/df/23/0a03d2d01c004ab3f0181bbda3642c7d88226b4a25f47675ef948326504f/fickling-0.1.4.tar.gz"
    sha256 "cb06bbb7b6a1c443eacf230ab7e212d8b4f3bb2333f307a8c94a144537018888"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/50/fb/396d568039d21344639db96d940d40eb62befe704ef849b27949ded5c3bb/intervaltree-3.1.0.tar.gz"
    sha256 "902b1b88936918f9b2a19e0e5eb7ccb430ae45cde4f39ea4b36932920d33952d"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/8d/b4/d09c00cb7bc88b17118be48f94d4b8d0ce7b572690625ca2b5477e05ce0e/json5-0.9.5.tar.gz"
    sha256 "703cfee540790576b56a92e1c6aaa6c4b0d98971dc358ead83812aa4d06bdb96"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "stdlib-list" do
    url "https://files.pythonhosted.org/packages/5d/09/8d5c564931ae23bef17420a6c72618463a59222ca4291a7dd88de8a0d490/stdlib_list-0.11.1.tar.gz"
    sha256 "95ebd1d73da9333bba03ccc097f5bac05e3aa03e6822a0c0290f87e1047f1857"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphtage --version 2>&1")
  end
end
