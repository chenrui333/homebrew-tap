class Rshell < Formula
  include Language::Python::Virtualenv

  desc "Remote Shell for MicroPython"
  homepage "https://github.com/dhylands/rshell"
  url "https://files.pythonhosted.org/packages/c7/ce/d802cd6363e709f36652c27c47d1ec411bc11eeb25bb472c711855e56038/rshell-0.0.36.tar.gz"
  sha256 "4a66d835207479550e59d0dd3e83003d04c4eca78a4e49250f887ed2dd4b0bf5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67da65ed8100858373afefac209b5a11e64b35313f052969a50fb9401cf9d4b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eb3932d31247bce16245ad40849aec8e393dc466f52439b1914b8a7063995d7"
    sha256 cellar: :any_skip_relocation, ventura:       "a3cc110de01312ffc3aa2bc540380434a479e9eb19b12bf27288b87dfa06abef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9b82a7384824707a8de0ddc328a01a2f646566faeaf048b1548c260296e3ba7"
  end

  depends_on "python@3.13"

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyudev" do
    url "https://files.pythonhosted.org/packages/c4/5c/6cc034da13830e3da123ccf9a30910bc868fa16670362f004e4b788d0df1/pyudev-0.24.3.tar.gz"
    sha256 "2e945427a21674893bb97632401db62139d91cea1ee96137cc7b07ad22198fc7"
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
