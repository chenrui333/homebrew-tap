class Parqv < Formula
  include Language::Python::Virtualenv

  desc "TUI for visualizing and analyzing files with multiple formats"
  homepage "https://github.com/sanspareilsmyn/parqv"
  url "https://files.pythonhosted.org/packages/07/f6/5f96e7d0d808b6eeac264fd11b233fb9cb4f9f9444e218d12397620eb6c6/parqv-0.3.0.tar.gz"
  sha256 "28599e3050eeac98080849cd925363c1b9fa29a40bb5342846da24a3e4de1dab"
  license "Apache-2.0"
  head "https://github.com/sanspareilsmyn/parqv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "f7df9632e48550d38f51c687c817f3a2afc7add6e65de7ff52cbab0dca9c57a6"
    sha256 cellar: :any, arm64_sequoia: "9477c4f179d54da37c2ee39af10af1897be5e0253215dd5a660b2f17e214c02b"
    sha256 cellar: :any, arm64_sonoma:  "388af71fee1be190a09deb8fc25fa618d05b30d00983d784435bfb1143c7469e"
    sha256               arm64_linux:   "223f314402c42904424117ac967f1ffebae540ecf6f0c57f5cd8bc188c5b2849"
    sha256               x86_64_linux:  "41cb892e307a768b594bee045436c06b6203065d63720bad4ba84a96c0c776c1"
  end

  depends_on "cmake" => :build # for pyarrow
  depends_on "ninja" => :build # for pyarrow
  depends_on "apache-arrow"
  depends_on "numpy"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages exclude_packages: "numpy"

  resource "duckdb" do
    url "https://files.pythonhosted.org/packages/81/99/ac6c105118751cc3ccae980b12e44847273f3402e647ec3197aff2251e23/duckdb-1.4.2.tar.gz"
    sha256 "df81acee3b15ecb2c72eb8f8579fb5922f6f56c71f5c8892ea3bc6fab39aa2c4"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/33/01/d40b85317f86cf08d853a4f495195c73815fdf205eef3993821720274518/pandas-2.3.3.tar.gz"
    sha256 "e05e1af93b977f7eafa636d043f9f94c7ee3ac81af99c13508215942e64c993b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/30/53/04a7fdc63e6056116c9ddc8b43bc28c12cdd181b85cbeadb79278475f3ae/pyarrow-22.0.0.tar.gz"
    sha256 "3d600dc583260d845c7d8a6db540339dd883081925da2bd1c5cb808f720b3cd9"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/f6/2f/f0b408f227edca21d1996c1cd0b65309f0cbff44264aa40aded3ff9ce2e1/textual-6.6.0.tar.gz"
    sha256 "53345166d6b0f9fd028ed0217d73b8f47c3a26679a18ba3b67616dcacb470eec"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/parqv nonexistent.csv 2>&1", 1)

    assert_match "File not found or is not a regular file", output
    assert_match ".parquet, .json, .ndjson, .csv", output
  end
end
