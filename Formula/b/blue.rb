class Blue < Formula
  include Language::Python::Virtualenv

  desc "Slightly less uncompromising Python code formatter"
  homepage "https://blue.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/68/5a/ef15e7accbe49dbeeb8e7c01e13b8459006c6fed4db8fe833f2ae4924fd7/blue-0.9.1.tar.gz"
  sha256 "76b4f26884a8425042356601d80773db6e0e14bebaa7a59d7c54bf8cef2e2af5"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54c98b767dcb423f9e5c6f91e5aab4987353b2677899c08058b6a47552872bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "506cfe191dff63c2836d1a60ff46d2f75a7ceca0cd4cf19e06ed974acb22b3fa"
    sha256 cellar: :any_skip_relocation, ventura:       "7bb0d122f907c53d1a7ad695dc98185217230c6adcf0e26b856a02a0d01abc27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90da82b54b60409cbc67a0cd343a725756af3fb10f3ba8406a52658f45721ed"
  end

  depends_on "python@3.13"

  resource "black" do
    url "https://files.pythonhosted.org/packages/42/58/8a3443a5034685152270f9012a9d196c9f165791ed3f2777307708b15f6c/black-22.1.0.tar.gz"
    sha256 "a7c0192d35635f6fc1174be575cb7915e92e5dd629ee79fdaf0dcfa41a80afb5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
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
    url "https://files.pythonhosted.org/packages/18/87/302344fed471e44a87289cf4967697d07e532f2421fdaf868a303cbae4ff/tomli-2.2.1.tar.gz"
    sha256 "cd45e1dc79c835ce60f7404ec8119f2eb06d38b1deba146f07ced3bbc44505ff"
  end

  def install
    virtualenv_install_with_resources

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
