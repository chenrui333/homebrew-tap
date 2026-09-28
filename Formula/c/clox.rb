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

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/0d/1c/73e719955c59b8e424d015ab450f51c0af856ae46ea2da83eba51cc88de1/setuptools-81.0.0.tar.gz"
    sha256 "487b53915f52501f0a79ccfd0c02c165ffe06631443a886740b91af4b7a5845a"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/c2/e3/7ca82ee24c82d344584abd5b8637b3bd056f2900226e8d82fc22f1184b92/trove_classifiers-2026.6.1.19.tar.gz"
    sha256 "c5132b4b61a829d11cfbd2d72e97f20a45ed6edb95e45c5efdeb5e00836b2745"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

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

  deny_network_access!

  def install
    build_resources = %w[
      setuptools
      flit-core
      packaging
      pathspec
      pluggy
      trove-classifiers
      hatchling
      wheel
    ]

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |resource| build_resources.include?(resource.name) },
                     build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clox --version")
    assert_match "Countries list:", shell_output("#{bin}/clox --countries-list")
  end
end
