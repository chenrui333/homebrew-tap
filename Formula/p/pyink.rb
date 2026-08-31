class Pyink < Formula
  include Language::Python::Virtualenv

  desc "Python formatter, forked from Black with a few different formatting behaviors"
  homepage "https://github.com/google/pyink"
  url "https://files.pythonhosted.org/packages/41/0d/6cbff4b5f012c682b8b65b44b17bea6bbcd5d38a33e4d6dfe70827c60f7c/pyink-26.5.1.tar.gz"
  sha256 "d74d3aa19102069a679160be50cc1340e2fa9d04eece25c24c583e0d85404302"
  license "MIT"
  head "https://github.com/google/pyink.git", branch: "pyink"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad5bd15885b0fec3d7b3cacba2d548ef8b4231eea6c19ee9c315c9362b92ba37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9880b3aa85df9d784bea9b7f5769399d1414632c2c5de0eb91e2caa97ecee5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60e3efef30559e96b56531ab2704f716e620630f0f4cd838d1e668536b039b55"
    sha256 cellar: :any,                 arm64_linux:   "f5a9bc21dc30f74f7bb141fd08ed415aef1e19d1904895e1e8faa6cfa05de5b5"
    sha256 cellar: :any,                 x86_64_linux:  "80eeeab2bdf33898bb69718d4287b8a11ce1bcb794f34c5909a1c7d040217295"
  end

  depends_on "rust" => :build
  depends_on "python@3.13"

  resource "black" do
    url "https://files.pythonhosted.org/packages/c0/37/5628dd55bf2b34257fc7603f0fe97c40e3aaf24265f416a9c85c95ca1436/black-26.5.1.tar.gz"
    sha256 "dd321f668053961824bcc1be1cc1df748b2d7e4fa28086b08331e577b0100a73"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/50/bb/ebc6636e1ae41314f796ebb7215fd28febb45f9aac72f2b04cb74b5071dc/platformdirs-4.11.4.tar.gz"
    sha256 "f3373be828247211d0febabea97e238c3dfde8a60b3c90c32756fb52cb21556d"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pyink", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyink --version")

    (testpath/"test.py").write <<~PYTHON
      def foo():
          print( "Hello, World!" )
    PYTHON

    # Return code 0 means nothing would change.
    # Return code 1 means some files would be reformatted.
    # Return code 123 means there was an internal error
    output = shell_output("#{bin}/pyink --check test.py 2>&1", 1)
    assert_match "1 file would be reformatted", output
    assert_match <<~EOS, shell_output("#{bin}/pyink test.py 2>&1")
      reformatted test.py

      All done! ✨ 🍰 ✨
      1 file reformatted.
    EOS

    formatted_content = (testpath/"test.py").read
    expected_content = <<~PYTHON
      def foo():
          print("Hello, World!")
    PYTHON

    assert_equal expected_content, formatted_content
  end
end
