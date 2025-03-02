class Brunette < Formula
  include Language::Python::Virtualenv

  desc "Best practice Python code formatter"
  homepage "https://github.com/ODwyerSoftware/brunette"
  url "https://files.pythonhosted.org/packages/33/c8/9d890d7d9ac93c8e9a66fa6e3b3f9518eec850609cc3556d28df259f3202/brunette-0.2.8.tar.gz"
  sha256 "e7d0766d3a4b0d18bf0f8830b4bc98a4af4ebcccf89c3b145fc92f9d4727d79b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d921d24290d26355f3911f05a136b4f3b6ea6d82a41e061c5fb26bca27d6dfa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ed2215a2f16f300ad644e30c24d47f7632bfa7176da07e7dbb4fc5f81809c2d"
    sha256 cellar: :any_skip_relocation, ventura:       "d5448343597914db515196c982b8e47fa94c54e012681323aeb91c4f31250e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf30f28ac8d5476f2f0315746b1d993b7e03cb2fd3ce95b26c7607b3c50e935b"
  end

  depends_on "python@3.13"

  resource "black" do
    url "https://files.pythonhosted.org/packages/f7/60/7a9775dc1b81a572eb26836c7e77c92bf454ada00693af4b2d2f2614971a/black-21.12b0.tar.gz"
    sha256 "77b80f693a569e2e527958459634f18df9b0ba2625ba4e0c2d5da5be42e6f2b3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/fb/2e/d0a8276b0cf9b9e34fd0660c330acc59656f53bb2209adc75af863a3582d/tomli-1.2.3.tar.gz"
    sha256 "05b6166bff487dc068d322585c7ea4ef78deed501cc124060e0f238e89a9231f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    # add an empty `requirements-dev.txt` to fix `No such file or directory: 'requirements-dev.txt'`
    (buildpath/"requirements-dev.txt").write ""

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"brunette", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    system bin/"brunette", "--version"

    (testpath/"test.py").write <<~PYTHON
      def foo():
          print( "Hello, World!" )
    PYTHON

    assert_match <<~EOS, shell_output("#{bin}/brunette test.py 2>&1")
      reformatted test.py
      All done! ✨ 🍰 ✨
      1 file reformatted.
    EOS

    expected_content = <<~PYTHON
      def foo():
          print("Hello, World!")
    PYTHON

    assert_equal expected_content, (testpath/"test.py").read
  end
end
