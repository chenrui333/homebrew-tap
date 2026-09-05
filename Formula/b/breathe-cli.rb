class BreatheCli < Formula
  include Language::Python::Virtualenv

  desc "Paced resonance breathing in your terminal"
  homepage "https://github.com/marekkowalczyk/breathe-cli"
  url "https://github.com/marekkowalczyk/breathe-cli/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "7eff35359860241a0217ae4a99aebbdf4f6f4f316ee02b6438ea6afdeb8f32ad"
  license "MIT"
  head "https://github.com/marekkowalczyk/breathe-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bf545378ebc7c68a9c726a17aeedaec03cf5be7450679cd19d3c52011b6ca92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf545378ebc7c68a9c726a17aeedaec03cf5be7450679cd19d3c52011b6ca92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bf545378ebc7c68a9c726a17aeedaec03cf5be7450679cd19d3c52011b6ca92"
    sha256 cellar: :any_skip_relocation, sequoia:       "0b50f2a00780a2e52192e3410ecda2459f155dc459fcc397b342e8c4304b586c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b50f2a00780a2e52192e3410ecda2459f155dc459fcc397b342e8c4304b586c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b50f2a00780a2e52192e3410ecda2459f155dc459fcc397b342e8c4304b586c"
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
