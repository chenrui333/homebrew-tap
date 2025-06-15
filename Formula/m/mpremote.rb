class Mpremote < Formula
  include Language::Python::Virtualenv

  desc "Tool for interacting remotely with MicroPython devices"
  homepage "https://docs.micropython.org/en/latest/reference/mpremote.html"
  url "https://files.pythonhosted.org/packages/86/1d/4a194eb385133349954cbf269e673e59e28b9510c7805e955da1cd32f4c6/mpremote-1.25.0.tar.gz"
  sha256 "d0dcd8ab364d87270e1766308882e536e541052efd64aadaac83bc7ebbea2815"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "820a6f816a48d4c754d6da316586d0f962912dc3d963cec9cc06c12d80d22282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c5082f733baf556a081d342f23c15d5640d12cc2c4ec1b089250edc2b53bcd9"
    sha256 cellar: :any_skip_relocation, ventura:       "aafc672fcefd1c8899be354bf12a3805c6d3fd4cebaa2b6540c9bc4f621666d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d304561e9eaeb3230627b044d31026322b3580beecafd4b06b1f7690823b492"
  end

  depends_on "python@3.13"

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpremote --version")
    assert_match "no device found", shell_output("#{bin}/mpremote soft-reset 2>&1", 1)
  end
end
