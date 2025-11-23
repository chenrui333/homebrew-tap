class Rshell < Formula
  include Language::Python::Virtualenv

  desc "Remote Shell for MicroPython"
  homepage "https://github.com/dhylands/rshell"
  url "https://files.pythonhosted.org/packages/c7/ce/d802cd6363e709f36652c27c47d1ec411bc11eeb25bb472c711855e56038/rshell-0.0.36.tar.gz"
  sha256 "4a66d835207479550e59d0dd3e83003d04c4eca78a4e49250f887ed2dd4b0bf5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ff1cf4fefe9f79e2beb7c64f6abdd4a56e07825014d9275bc372a4a7a02e0c03"
  end

  depends_on "python@3.14"

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyudev" do
    url "https://files.pythonhosted.org/packages/5e/1d/8bdbf651de1002e8b58fbe817bee22b1e8bfcdd24341d42c3238ce9a75f4/pyudev-0.24.4.tar.gz"
    sha256 "e788bb983700b1a84efc2e88862b0a51af2a995d5b86bc9997546505cf7b36bc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rshell --version")

    output = shell_output("#{bin}/rshell --debug --list")
    assert_match "Debug = True", output
  end
end
