class Xmlformatter < Formula
  include Language::Python::Virtualenv

  desc "Format and compress XML documents"
  homepage "https://github.com/pamoller/xmlformatter"
  url "https://files.pythonhosted.org/packages/24/86/1cdcb604b04c08e83366dc082611795695f08fc38700344ddb81342c63a8/xmlformatter-0.2.8.tar.gz"
  sha256 "ddc82e7cb4ff2669f54014e2eaf86b493d5e2da95b536f974f0a15f02763f64c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "171d09c8a894c2113ae345105dfc5a43a6fa79032fb396ec45a38b9858f41070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a95f84ab64bad146e971177133e67bb8befd228f6f0a36e65e59b882933ef964"
    sha256 cellar: :any_skip_relocation, ventura:       "c08641b0923b78d60336050c74e21b36bdb289f551f4c0a3189c8b463fd49d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e526923af680bee9fd86f6ed3f8d3cbd7b66d61e62328386c9545c5f2aefc7ff"
  end

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
