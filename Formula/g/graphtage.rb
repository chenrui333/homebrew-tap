class Graphtage < Formula
  include Language::Python::Virtualenv

  desc "Semantic diff utility for tree-like files such as JSON/JSON5/XML/HTML/YAML/CSV"
  homepage "https://github.com/trailofbits/graphtage"
  url "https://files.pythonhosted.org/packages/f3/51/46ae661912683e99f33fb4245a68e97a2fa8bc1e800ea65c983654028278/graphtage-0.3.1.tar.gz"
  sha256 "8650d1ca566f9ab4dbbd340c159131ce611f318f41014af47eaaac801e021d3b"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "e7ff37a1852efcd1c44de3ab85f2d6f73c7022135c4eb0b67bc712d447061526"
    sha256 cellar: :any,                 arm64_sonoma:  "69d71f5ae10c9e9fda20253f7d8263e98569efdcc0efd057467a927a5abe02c2"
    sha256 cellar: :any,                 ventura:       "f5449a05e6d211881f97f1770b102cb9559ce6a12c2ed0757791fa926edaf0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34def5b4d0b5d259fb6947abc76b0f1bd46fa2ddb619bf6ea13d3370cbecfab3"
  end

  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python-setuptools" # for distutils
  depends_on "python@3.13"
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
    url "https://files.pythonhosted.org/packages/70/81/c12ae44e1e53b4673f713025da48df4fa91aff9630b2019d418b39638876/fickling-0.1.3.tar.gz"
    sha256 "606b3153ad4b2c0338930d08a739f7f10a560f996e0bd3a4b46544417254b0d0"
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
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphtage --version 2>&1")
  end
end
