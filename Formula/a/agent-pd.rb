class AgentPd < Formula
  include Language::Python::Virtualenv

  desc "Audit hook and CLI that reports rule offenses by Claude Code agents"
  homepage "https://github.com/varmabudharaju/agent-pd"
  url "https://github.com/varmabudharaju/agent-pd/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "13d18c536e0a720d89c1db67661a94c0032f31c46468740dcf465ad33610ab1b"
  license "Apache-2.0"
  head "https://github.com/varmabudharaju/agent-pd.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd4e8aa6f77d4dc83992ed1da893adb4e71f0ce12ac7a6e909c1485e6085c283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "796b0de15d7f32f6fedb9663d16cb3b88c155ec93e1a542815c4a93b7adc0654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14bb7570ceec3293b574440ef23393d057376582fa48ef6c0f43048643581572"
    sha256 cellar: :any,                 arm64_linux:   "fe32f7217f8ff056ebf9de1d99a804d7539741ac7b9f744f54443e3ccc3db5e3"
    sha256 cellar: :any,                 x86_64_linux:  "9991012914d6adfaf720309aab95a7444f062a7c4433619d8aa01c463f47f841"
  end

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
