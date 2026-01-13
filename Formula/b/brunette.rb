class Brunette < Formula
  include Language::Python::Virtualenv

  desc "Best practice Python code formatter"
  homepage "https://github.com/ODwyerSoftware/brunette"
  url "https://files.pythonhosted.org/packages/33/c8/9d890d7d9ac93c8e9a66fa6e3b3f9518eec850609cc3556d28df259f3202/brunette-0.2.8.tar.gz"
  sha256 "e7d0766d3a4b0d18bf0f8830b4bc98a4af4ebcccf89c3b145fc92f9d4727d79b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddcd367e6eadfa0b5c965464813f07331c511a78d961712c305ba94dd3af5ec3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02e2d269c6e7b276423531f1225b220eae17f1ecd05285a06c4c58469d898cf"
    sha256 cellar: :any_skip_relocation, ventura:       "10e907cced2dcc61a179c547ed5d47b48d951146a88fc6b1c8e5f15383b4b5f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3fbdde53b4427c31a3809e98b6e9701afc68a0059b97488b85151807af8bac"
  end

  depends_on "python@3.14"

  resource "black" do
    url "https://files.pythonhosted.org/packages/f7/60/7a9775dc1b81a572eb26836c7e77c92bf454ada00693af4b2d2f2614971a/black-21.12b0.tar.gz"
    sha256 "77b80f693a569e2e527958459634f18df9b0ba2625ba4e0c2d5da5be42e6f2b3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/fb/2e/d0a8276b0cf9b9e34fd0660c330acc59656f53bb2209adc75af863a3582d/tomli-1.2.3.tar.gz"
    sha256 "05b6166bff487dc068d322585c7ea4ef78deed501cc124060e0f238e89a9231f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
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
