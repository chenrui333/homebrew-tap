class Xmlformatter < Formula
  include Language::Python::Virtualenv

  desc "Format and compress XML documents"
  homepage "https://github.com/pamoller/xmlformatter"
  url "https://files.pythonhosted.org/packages/24/86/1cdcb604b04c08e83366dc082611795695f08fc38700344ddb81342c63a8/xmlformatter-0.2.8.tar.gz"
  sha256 "ddc82e7cb4ff2669f54014e2eaf86b493d5e2da95b536f974f0a15f02763f64c"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.xml").write <<~XML
      <root><child>content</child></root>
    XML

    system bin/"xmlformat", "--indent", "2", "--outfile", "formatted.xml", "test.xml"
    expected_content = <<~XML
      <root>
        <child>content</child>
      </root>
    XML

    assert_equal expected_content.chomp, (testpath/"formatted.xml").read
  end
end
