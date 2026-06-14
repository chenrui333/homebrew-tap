class AgentPd < Formula
  include Language::Python::Virtualenv

  desc "Audit hook and CLI that reports rule offenses by Claude Code agents"
  homepage "https://github.com/varmabudharaju/agent-pd"
  url "https://github.com/varmabudharaju/agent-pd/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "13d18c536e0a720d89c1db67661a94c0032f31c46468740dcf465ad33610ab1b"
  license "Apache-2.0"
  head "https://github.com/varmabudharaju/agent-pd.git", branch: "master"

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/pd --help")
    assert_match "pd", output

    output = shell_output("#{bin}/pd report 2>&1")
    assert_match "no sessions found", output
  end
end
