class Blue < Formula
  include Language::Python::Virtualenv

  desc "Slightly less uncompromising Python code formatter"
  homepage "https://blue.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/68/5a/ef15e7accbe49dbeeb8e7c01e13b8459006c6fed4db8fe833f2ae4924fd7/blue-0.9.1.tar.gz"
  sha256 "76b4f26884a8425042356601d80773db6e0e14bebaa7a59d7c54bf8cef2e2af5"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "20347bff96a304bf3774e8af5aaaaf447ef6980c276829bf325dda0b30c38a07"
  end

  # cannot upgrade to python 3.14 due to `module 'ast' has no attribute 'Str'` error
  depends_on "python@3.13"

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/3c/87/1ff7adcf6e03021ae58ce401565be3c9b8c739a44d14a8253d38b3754117/setuptools_scm-10.2.3.tar.gz"
    sha256 "f179ed3e2a63cf5823e5ee9aa9ca08386219400443a0553224d72dde3f206b44"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/3e/97/792a4ef20344f9af3e16098b58b45eb5d6202259b84fc80c43bc000a5e6c/vcs_versioning-2.4.1.tar.gz"
    sha256 "d4575de3115ec9434393c87c80ffb0eb98a16056bfe2b11ce0f3a97aff67fe0a"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/42/58/8a3443a5034685152270f9012a9d196c9f165791ed3f2777307708b15f6c/black-22.1.0.tar.gz"
    sha256 "a7c0192d35635f6fc1174be575cb7915e92e5dd629ee79fdaf0dcfa41a80afb5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "flake8" do
    url "https://files.pythonhosted.org/packages/e6/84/d8db922289195c435779b4ca3a3f583f263f87e67954f7b2e83c8da21f48/flake8-4.0.1.tar.gz"
    sha256 "806e034dda44114815e23c16ef92f95c91e4c71100ff52813adf7132a6ad870d"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/08/dc/b29daf0a202b03f57c19e7295b60d1d5e1281c45a6f5f573e41830819918/pycodestyle-2.8.0.tar.gz"
    sha256 "eddd5847ef438ea1c7870ca7eb78a9d47ce0cdb4851a5523949f2601d0cbbe7f"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/15/60/c577e54518086e98470e9088278247f4af1d39cb43bcbd731e2c307acd6a/pyflakes-2.4.0.tar.gz"
    sha256 "05a85c2872edf37a4ed30b0cce2f6093e1d0581f8c19d7393122da7e25b2b24c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/52/ed/3f73f72945444548f33eba9a87fc7a6e969915e7b1acc8260b30e1f76a2f/tomli-2.3.0.tar.gz"
    sha256 "64be704a875d2a59753d80ee8a533c3fe183e3f06807ff7dc2232938ccb01549"
  end

  deny_network_access!

  def install
    build_resources = %w[
      setuptools flit-core packaging pathspec pluggy trove-classifiers vcs-versioning setuptools-scm hatchling
      hatch-vcs wheel
    ]

    venv = virtualenv_create(libexec, "python3.13")
    build_resources.each { |name| venv.pip_install resource(name), build_isolation: false }
    venv.pip_install resources.reject { |resource| build_resources.include?(resource.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false

    generate_completions_from_executable(bin/"blue", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/blue --version")

    (testpath/"test.py").write <<~PYTHON
      def foo():
          print( "Hello, World!" )
    PYTHON

    assert_match <<~EOS, shell_output("#{bin}/blue test.py 2>&1")
      reformatted test.py

      All done! ✨ 🍰 ✨
      1 file reformatted.
    EOS

    expected_content = <<~PYTHON
      def foo():
          print('Hello, World!')
    PYTHON

    assert_equal expected_content, (testpath/"test.py").read
  end
end
