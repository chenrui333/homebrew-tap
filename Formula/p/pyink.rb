class Pyink < Formula
  include Language::Python::Virtualenv

  desc "Python formatter, forked from Black with a few different formatting behaviors"
  homepage "https://github.com/google/pyink"
  url "https://files.pythonhosted.org/packages/d1/a1/e5e28626fca4266a94c2e1c9264fbf915b9e83e94f52e965190e48fd0cbf/pyink-24.10.1.tar.gz"
  sha256 "5ec4339aa4953f796e88d90bcac3e3472161e4c36dbde203d80f5f76721ac718"
  license "MIT"
  head "https://github.com/google/pyink.git", branch: "pyink"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69bb88d779fe23c40681d0d900c972535744d1011816cd491060db7ef522989b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e348bf59a3082c53dec2884ce5e30e1ac2b8e52200ce2e4aa3c3d3ff08af40ac"
    sha256 cellar: :any_skip_relocation, ventura:       "58b5072738d19db5e9af418c0e957c59cbe19c8bdda3fc805705e256d3315d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67a7e53ca643572a0822e5ddd81004b6b2c5bc48b5f5df509bf2632bfd49faeb"
  end

  depends_on "python@3.13"

  resource "black" do
    url "https://files.pythonhosted.org/packages/d8/0d/cc2fb42b8c50d80143221515dd7e4766995bd07c56c9a3ed30baf080b6dc/black-24.10.0.tar.gz"
    sha256 "846ea64c97afe3bc677b761787993be4991810ecc7a4a937816dd6bddedc4875"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  def install
    virtualenv_install_with_resources
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
