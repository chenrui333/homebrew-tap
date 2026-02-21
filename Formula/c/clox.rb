class Clox < Formula
  include Language::Python::Virtualenv

  desc "Geeky clock for terminal enthusiasts"
  homepage "https://github.com/sepandhaghighi/clox"
  url "https://files.pythonhosted.org/packages/f5/13/13629052a267e06bf5a9cf687eec42eb9d86949689de942ee40b3f335b93/clox-1.6.tar.gz"
  sha256 "8501197eebd771696754147adbb0574314f14db51f21b12b07d970fa944ee439"
  license "MIT"
  head "https://github.com/sepandhaghighi/clox.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "984abc19ea0791e2831b62249e944fc92d08f0a02a6eb75b5a0fc1f0c9367f54"
  end

  depends_on "python@3.14"

  resource "art" do
    url "https://files.pythonhosted.org/packages/d4/7d/7d80509bbd19fb747edef94ba487dbadd2747944774ccc0528ad0d005a36/art-6.5.tar.gz"
    sha256 "a98d77b42c278697ec6cf4b5bdcdfd997f6b2425332da078d4e31e31377d1844"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jalali-core" do
    url "https://files.pythonhosted.org/packages/2b/3c/21e32e3444c572174a5d774643eb2aa8ab60ef68b99a4c3585a0a11428b4/jalali_core-1.0.0.tar.gz"
    sha256 "f4287c70c630323dcf0a3ab26df905ba4d451e230ac1f65b3bb2f77797894a2b"
  end

  resource "jdatetime" do
    url "https://files.pythonhosted.org/packages/6e/9d/5ed59c36f3cbc68c01fab6442e6efb6d35a484ba4eec4f790264fce39f6c/jdatetime-5.2.0.tar.gz"
    sha256 "c81d5898717b82b609a3ce2a73f8b8d3230b0c757e5c0de9d6b1acfdc224f551"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clox --version")
    assert_match "Countries list:", shell_output("#{bin}/clox --countries-list")
  end
end
