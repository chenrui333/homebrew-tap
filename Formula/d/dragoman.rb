class Dragoman < Formula
  include Language::Python::Virtualenv

  desc "CLI that lets Claude Code reach non-Anthropic models through a subagent"
  homepage "https://github.com/asakin/dragoman"
  url "https://files.pythonhosted.org/packages/4a/d1/224fc8440c65edbd3eac7c274537b5ffca51997a49c60d9dcc44610ba653/dragoman_ai-0.6.2.tar.gz"
  sha256 "a8276e94390b3c16626660493c800943d05326fa6f61ddae0c0cf79a9f244664"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "01880832fb19b891125611c5ab70925831fdceb44a484cbf237e2e86698732da"
  end

  depends_on "python@3.13"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dragoman --version")
    output = shell_output("#{bin}/dragoman --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
