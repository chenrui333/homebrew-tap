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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f6d288197e5d77c871c778f161ab141322b091ae82a634b8385c24b51c30f38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f6d288197e5d77c871c778f161ab141322b091ae82a634b8385c24b51c30f38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f6d288197e5d77c871c778f161ab141322b091ae82a634b8385c24b51c30f38"
    sha256 cellar: :any_skip_relocation, sequoia:       "3930173b94413378e4bae2aa51ba55257743384376487f8e45b8b95fd6bdebd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3930173b94413378e4bae2aa51ba55257743384376487f8e45b8b95fd6bdebd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3930173b94413378e4bae2aa51ba55257743384376487f8e45b8b95fd6bdebd5"
  end

  depends_on "python@3.13"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/0d/1c/73e719955c59b8e424d015ab450f51c0af856ae46ea2da83eba51cc88de1/setuptools-81.0.0.tar.gz"
    sha256 "487b53915f52501f0a79ccfd0c02c165ffe06631443a886740b91af4b7a5845a"
  end

  deny_network_access!

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resource("setuptools"), build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/breathe --version")
    output = shell_output("#{bin}/breathe --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
