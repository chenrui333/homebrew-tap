class Xmlformatter < Formula
  include Language::Python::Virtualenv

  desc "Format and compress XML documents"
  homepage "https://github.com/pamoller/xmlformatter"
  url "https://files.pythonhosted.org/packages/8e/3c/c82fe32478256a1d6cfae4770eda5e4da629e56f7d5a2baace308819c910/xmlformatter-0.2.9.tar.gz"
  sha256 "22266ce398950d7848df66d5edc1bee57ead6d1b2404184c335ac4d0892d2760"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "634be72e8938a12f0203ad46322c4e82ed5a88d08c1efd5351d4019956b12150"
  end

  depends_on "python@3.14"

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
