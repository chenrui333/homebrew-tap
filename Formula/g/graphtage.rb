class Graphtage < Formula
  include Language::Python::Virtualenv

  desc "Semantic diff utility for tree-like files such as JSON/JSON5/XML/HTML/YAML/CSV"
  homepage "https://github.com/trailofbits/graphtage"
  url "https://files.pythonhosted.org/packages/46/40/ddefc7850671761c85d1e017f1ea6ce6aec063f7a5949c22bbf16a469e71/graphtage-0.5.0.tar.gz"
  sha256 "29df3ec6fe23058da4166d2bb681e1601098e0b365dd9cea40b1957aee88fcfb"
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

  pypi_packages exclude_packages: %w[numpy scipy]

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "fickling" do
    url "https://files.pythonhosted.org/packages/d7/20/d3c2bdb9235b777763a4afc7cc3673afcd162a707ec0988ae7141a540802/fickling-0.1.12.tar.gz"
    sha256 "83f6ccc948e21edb9ebd92795069536b47f481ce6add62598eac608b31576821"
  end

  resource "intervaltree" do
    url "https://files.pythonhosted.org/packages/53/c3/b2afa612aa0373f3e6bb190e6de35f293b307d1537f109e3e25dbfcdf212/intervaltree-3.2.1.tar.gz"
    sha256 "f3f7e8baeb7dd75b9f7a6d33cf3ec10025984a8e66e3016d537e52130c73cfe2"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/e4/7d/05c46a96a78147ae3bf99c2f4169ce144a70220b8d6fcd56f6ec368b8ce9/json5-0.15.0.tar.gz"
    sha256 "7424d1f1eb1d56da6e3d70643f53619862b4ce81440bdb8ecfd6f875e5ba4a71"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphtage --version 2>&1")
  end
end
