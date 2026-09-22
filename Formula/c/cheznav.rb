class Cheznav < Formula
  include Language::Python::Virtualenv

  desc "TUI for chezmoi"
  homepage "https://github.com/DJetelina/cheznav"
  url "https://files.pythonhosted.org/packages/32/f0/df44f4cc1db5b9412c72d9c824b7a924d49c8762e3095d45bb9346b42181/cheznav-0.3.0.tar.gz"
  sha256 "2c09aeca9719367d7fb8ac8e320dd2dde4e359631a6a63574a2fc8deedfe5362"
  license "MIT"
  head "https://github.com/DJetelina/cheznav.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b3d79783bb3e0c1c4a86552290844a03fc0513d1c3964312ca28b68e1bd4c9c4"
  end

  depends_on "chezmoi"
  depends_on "python@3.14"

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/38/2a/8ea4bd54734f0fcbb507c28cb6b79d72f528e40498178a01cb35fc5d686f/flit_core-4.1.0-py3-none-any.whl"
    sha256 "17398cdd2c38b24047a5a9c93089ec5c0bf12ec3d1469bbf69c27ed7965299db"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/5f/48/1f85cee4b7b4f40b9b814b1febbc661bda6ced9649e410a0b74f6e415dd0/hatch_vcs-0.5.0-py3-none-any.whl"
    sha256 "b49677dbdc597460cc22d01b27ab3696f5e16a21ecf2700fb01bc28e1f2a04a7"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/5f/80/91f51f439c05d4ec4623c22928ce16a938d6d793bf709477830823497859/hatchling-1.32.4-py3-none-any.whl"
    sha256 "08ecf7548fb48205e7f213d70c71e67b8271b7242093dc3f1da578b42c734a2c"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/13/d4/1152d1c7ab42d8b908be64fd200ddc870dc9d4925e951198702084aa1a7d/linkify_it_py-2.2.0-py3-none-any.whl"
    sha256 "3adc40eb5af300b2605fcfdb968c24e1d780a90f1f2221af7c15e5111e94d443"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/b3/81/4da04ced5a082363ecfa159c010d200ecbd959ae410c10c0264a38cac0f5/markdown_it_py-4.2.0-py3-none-any.whl"
    sha256 "9f7ebbcd14fe59494226453aed97c1070d83f8d24b6fc3a3bcf9a38092641c4a"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/a5/69/6da5581c6a7fede7dc261bf4e67d6adca4196f176b43288b55b3db395b6e/mdit_py_plugins-0.6.1-py3-none-any.whl"
    sha256 "214c82fb2ac524472ab6a5bcab1de80f73b50443e187f401bfd77efbc7c6481d"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/b3/38/89ba8ad64ae25be8de66a6d463314cf1eb366222074cfda9ee839c56a4b4/mdurl-0.1.2-py3-none-any.whl"
    sha256 "84008a41e51615a49fc9966191ff91509e3c40b939176e643fd50a5c2196b8f8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/63/34/ba1c580383c9eada3711951fef0795c80b829a078d72188184bcab9dd527/packaging-26.3-py3-none-any.whl"
    sha256 "d7193f7c8e4e93f444fde0262bf90af30e16fa0ad0ad44cb553c87339b23cd1c"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f1/d9/7fb5aa316bc299258e68c73ba3bddbc499654a07f151cba08f6153988714/pathspec-1.1.1-py3-none-any.whl"
    sha256 "a00ce642f577bf7f473932318056212bc4f8bfdf53128c78bbd5af0b9b20b189"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ec/2b/69de6317fbf48865bb12aa56c9cfcfff46b3add0cd45250725d96146dce0/platformdirs-4.11.12-py3-none-any.whl"
    sha256 "b1ba966ac76153d9985a0787ffab951e7c18416189873d4e4ddb2c8a04a0a254"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/20/4d324d65cc6d9205fabedc306948156824eb9f0ee1633355a8f7ec5c66bf/pluggy-1.6.0-py3-none-any.whl"
    sha256 "e920276dd6813095e9377c0bc5566d94c932c33b27a3e3945d8389c374dd4746"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/71/46/17f022dd3e953bf20a04a028a21ec746d942f8d2af30fa0f124fa0e6a684/pygments-2.21.0-py3-none-any.whl"
    sha256 "2363c69b61c4a97c838da3b130dcd6468f4848992b21a82f2a63ec34377137d9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/82/3b/64d4899d73f91ba49a8c18a8ff3f0ea8f1c1d75481760df8c68ef5235bf5/rich-15.0.0-py3-none-any.whl"
    sha256 "33bd4ef74232fb73fe9279a257718407f169c09b78a87ad3d296f548e27de0bb"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/95/9c/c510029fc6ef33a6275cd2c5d3cecd6613dfd6aa401d57c54f1c18852ccf/setuptools-84.0.0-py3-none-any.whl"
    sha256 "51a52592b3b99e102b609654876bd65f19f999935166d1352678931132b0c670"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/4b/00/e9c0591b77186f6c1a8479500456ee72cd30730836c58b7a8a2654909c23/setuptools_scm-10.2.3-py3-none-any.whl"
    sha256 "7fcf8ff55c95eb8b572a23c81495e5559b9b90f3e82fcf0952bb76c37de27a81"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/fb/be/35261223d9416a0751cdff1c7b4a6f881387218a12d439fe22fefebc8c04/textual-8.2.8-py3-none-any.whl"
    sha256 "267375fd402dc8d981457212efa71f0e3365fd17bba144ba9bb3ed7563cb374a"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/13/bc/8c13eb66537dce1d2bd3a57132902f38d0e7f5bb46fa9f4daed9fe9d76ee/tomlkit-0.15.1-py3-none-any.whl"
    sha256 "177a05aece5a8ca5266fd3c448abb47b8d352f09d477d3ca8332db4d89b24304"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/30/81/0da8afb52a71d0a4f2bd3152357b1a441e393b286374802b9d3addab4ab5/trove_classifiers-2026.9.21.13-py3-none-any.whl"
    sha256 "8b1ff4f9c191b1040b71c37f1e445ab99732911e3cd91de52838453a854d7a17"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/49/d3/b8441a820a491ddfc024b0b0cf0393375b75ea13866d9c66727e54c2fc80/typing_extensions-4.16.0-py3-none-any.whl"
    sha256 "481caa481374e813c1b176ada14e97f1f67a4539ce9cfeb3f350d78d6370c2e8"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/d7/20/29378edc8d7d2ce41892adc1356f4c6c6ae03b945d04ca6ade61afa3d5dc/vcs_versioning-2.4.1-py3-none-any.whl"
    sha256 "b7089ec9bef67b2cad82148366e8eac4d63173f440ec62628282b59eb96bbcb0"
  end

  deny_network_access!

  def install
    inreplace buildpath/"pyproject.toml",
      'requires = ["uv_build>=0.10.11,<0.12.0"]',
      'requires = ["setuptools"]'
    inreplace buildpath/"pyproject.toml",
      'build-backend = "uv_build"',
      'build-backend = "setuptools.build_meta"'

    venv = virtualenv_create(libexec, "python3.14")
    build_resources = %w[setuptools]
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    resources.reject { |r| build_resources.include?(r.name) }.each do |resource|
      venv.pip_install resource, build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    version_output = shell_output("#{libexec}/bin/python -c 'import cheznav; print(cheznav.__version__)'").strip
    assert_equal version.to_s, version_output

    output = shell_output("#{bin}/cheznav --not-a-real-option 2>&1", 2)
    assert_match "unrecognized arguments: --not-a-real-option", output
  end
end
