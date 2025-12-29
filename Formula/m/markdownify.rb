class Markdownify < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to Markdown"
  homepage "https://github.com/matthewwithanm/python-markdownify"
  url "https://files.pythonhosted.org/packages/3f/bc/c8c8eea5335341306b0fa7e1cb33c5e1c8d24ef70ddd684da65f41c49c92/markdownify-1.2.2.tar.gz"
  sha256 "b274f1b5943180b031b699b199cbaeb1e2ac938b75851849a31fd0c3d6603d09"
  license "MIT"
  head "https://github.com/matthewwithanm/python-markdownify.git", branch: "develop"

  depends_on "python@3.14"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/89/23/adf3796d740536d63a6fbda113d07e60c734b6ed5d3058d1e47fc0495e47/soupsieve-2.8.1.tar.gz"
    sha256 "4cf733bc50fa805f5df4b8ef4740fc0e0fa6218cf3006269afd3f9d6d80fd350"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.html").write <<~HTML
      <html>
        <head><title>Test Page</title></head>
        <body>
          <h1>Hello, World!</h1>
          <p>This is a <strong>test</strong> page.</p>
        </body>
      </html>
    HTML

    expected_markdown = <<~MARKDOWN
      Test Page


      Hello, World!
      =============

      This is a **test** page.
    MARKDOWN

    output = shell_output("#{bin}/markdownify #{testpath}/test.html")
    assert_equal expected_markdown, output
  end
end
