class BreatheCli < Formula
  include Language::Python::Virtualenv

  desc "Paced resonance breathing in your terminal"
  homepage "https://github.com/marekkowalczyk/breathe-cli"
  url "https://github.com/marekkowalczyk/breathe-cli/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "41ab1578c9c37ae06e81af4c1878d72ece1b3c23fcc57c9e5c9c65af7e4d8396"
  license "MIT"
  head "https://github.com/marekkowalczyk/breathe-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "30bc287df12e36b0714951c18f13e890c07e5be3c83a46867edbf6c7cd461b17"
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
