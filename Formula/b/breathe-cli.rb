class BreatheCli < Formula
  include Language::Python::Virtualenv

  desc "Paced resonance breathing in your terminal"
  homepage "https://github.com/marekkowalczyk/breathe-cli"
  url "https://github.com/marekkowalczyk/breathe-cli/archive/refs/tags/v1.9.tar.gz"
  sha256 "8842ea690828e6c4acfd1d0887ed86b7d209d863fc7b4c644581461412b4e2dd"
  license "MIT"
  head "https://github.com/marekkowalczyk/breathe-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "63b79abc27f3bd58aecb6cc66c9bdfabbd2d8ad4c1feeda2557931afcf8db151"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/breathe --version")
    output = shell_output("#{bin}/breathe --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
