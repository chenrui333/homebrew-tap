class Deface < Formula
  include Language::Python::Virtualenv

  desc "Video anonymization by face detection"
  homepage "https://github.com/ORB-HD/deface"
  url "https://files.pythonhosted.org/packages/1f/ac/4921cac040307d57d8e87ab4124e82f24dd492e1075bed5101cd8faf0dad/deface-1.5.0.tar.gz"
  sha256 "122468698f66cdec210dd581a73c94dfbf9a16cb16ae4644ae056534467d4934"
  license "MIT"
  head "https://github.com/ORB-HD/deface.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "eee1af5c455f4decf104a673a08400dcb781aee02d1c7f73a0f5306644f1a388"
  end

  depends_on "numpy" => :no_linkage
  depends_on "opencv"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "scikit-image" => :no_linkage
  depends_on "scipy" => :no_linkage

  pypi_packages exclude_packages: %w[numpy opencv-python pillow scikit-image scipy],
                extra_packages:   %w[flit-core setuptools setuptools-scm vcs-versioning wheel]

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/a3/6f/606be632e37bf8d05b253e8626c2291d74c691ddc7bcdf7d6aaf33b32f6a/imageio-2.37.2.tar.gz"
    sha256 "0212ef2727ac9caa5ca4b2c75ae89454312f440a756fcfc8ef1993e718f50f8a"
  end

  resource "imageio-ffmpeg" do
    url "https://files.pythonhosted.org/packages/44/bd/c3343c721f2a1b0c9fc71c1aebf1966a3b7f08c2eea8ed5437a2865611d6/imageio_ffmpeg-0.6.0.tar.gz"
    sha256 "e2556bed8e005564a9f925bb7afa4002d82770d6b08825078b7697ab88ba1755"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/6f/6b/c875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8/lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/f8/a6/85e8ecfd7cb4167f8bd17136b2d42cba296fbc08a247bba70d5747e2046a/tifffile-2025.12.20.tar.gz"
    sha256 "cb8a4fee327d15b3e3eeac80bbdd8a53b323c80473330bcfb99418ee4c1c827f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  deny_network_access!

  def install
    build_resources = %w[setuptools flit-core packaging wheel vcs-versioning setuptools-scm]
    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each { |name| venv.pip_install resource(name), build_isolation: false }
    venv.pip_install resources.reject { |resource| build_resources.include?(resource.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false

    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{formula_opt_libexec("scikit-image")/site_packages}')\n"
    (venv.site_packages/"homebrew-scikit-image.pth").write pth_contents
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"deface", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
