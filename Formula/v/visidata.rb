class Visidata < Formula
  include Language::Python::Virtualenv

  desc "Terminal spreadsheet multitool for discovering and arranging data"
  homepage "https://www.visidata.org/"
  url "https://files.pythonhosted.org/packages/6c/41/b026336b7075a2c8461c1ba0dfffd456902f736722f4a016f21fee1e6d7c/visidata-3.1.1.tar.gz"
  sha256 "8c4484158f0851e4887e595542bd65bdd991de9c20652b442b3fd9742ce8b031"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ad7b29e969d26059b32fb92243859ceb869a85a31bd1ac4e7cbad137bb9d752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d90ea68b09b7f82eac01b796eb78e5a9001ae6e77ec9c968201dafc453e9b1b"
    sha256 cellar: :any_skip_relocation, ventura:       "061eac8c856f6fd10c84c511cd94c82bead640d6b3f81d987a9b7c6f73dc31be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "263b674979d5437dec605a8604b9e2cbf92edea7bfc04767aacf502d887d1588"
  end

  depends_on "python@3.13"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/08/c1395a292bb23fd03bdf572a1357c5a733d3eecbab877641ceacab23db6e/importlib_metadata-8.6.1.tar.gz"
    sha256 "310b41d755445d74569f993ccfc22838295d9fe005425094fad953d7f15c8580"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources

    man1.install "visidata/man/visidata.1", "visidata/man/vd.1"
  end

  test do
    %w[vd visidata].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"test.csv").write <<~CSV
      name,age
      Alice,42
      Bob,34
    CSV

    assert_match "age", shell_output("#{bin}/vd -b -f csv test.csv")
  end
end
