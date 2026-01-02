class Pyink < Formula
  include Language::Python::Virtualenv

  desc "Python formatter, forked from Black with a few different formatting behaviors"
  homepage "https://github.com/google/pyink"
  url "https://files.pythonhosted.org/packages/31/45/5940abea3a364768b267ff4c73d898f7d692f649540e613a8fe67089abcc/pyink-25.12.0.tar.gz"
  sha256 "930a913fed2824ffbbd3c10847fad1171c2b075dd709a13dc435caea851de7b8"
  license "MIT"
  head "https://github.com/google/pyink.git", branch: "pyink"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5606b309b887ed38ebe58de2921d3f6553d918838068a92b62e7ab6deae95096"
  end

  depends_on "python@3.13"

  resource "black" do
    url "https://files.pythonhosted.org/packages/c4/d9/07b458a3f1c525ac392b5edc6b191ff140b596f9d77092429417a54e249d/black-25.12.0.tar.gz"
    sha256 "8d3dd9cea14bff7ddc0eb243c811cdb1a011ebb4800a5f0335a01a68654796a7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/4e/8d/a762be14dae1c3bf280202ba3172020b2b0b4c537f94427435f19c413b72/pytokens-0.3.0.tar.gz"
    sha256 "2f932b14ed08de5fcf0b391ace2642f858f1394c0857202959000b68ed7a458a"
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
