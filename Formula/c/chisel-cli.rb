class ChiselCli < Formula
  include Language::Python::Virtualenv

  desc "Accelerate your Python functions with cloud GPUs"
  homepage "https://github.com/Herdora/chisel"
  url "https://files.pythonhosted.org/packages/bb/96/71b46fa101744f0f330182cd47d4a0cf8c4cc8c126247d1bfcd61fa25eda/chisel_cli-0.1.32.tar.gz"
  sha256 "7b13e7c05d7bb82dbebb0b3e75301602e2bffa92241089d03d72416861233b55"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a7eedd893c50bccab67830acf6ae8b189d9c0855ca75d4e10aa81751b1e4c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab9d13b8e95450a318b657c8745a799515017166f2e8f92ff8ae1cc617b8108d"
    sha256 cellar: :any_skip_relocation, ventura:       "af7caf2543fdfc78c79e8806e4efd5ae96aed43e5eb4fcb2742fb0c614a5b00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e22aafc70392d996c80a30be60f8f20fb32261a13e46bbda53822c2f0371b1ea"
  end

  depends_on "python@3.13"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dc/67/960ebe6bf230a96cda2e0abcf73af550ec4f090005363542f0765df162e0/certifi-2025.8.3.tar.gz"
    sha256 "e564105f78ded564e3ae7c923924435e1daa7463faeab5bb932bc53ffae63407"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/chisel --version")
    system bin/"chisel", "--version"

    output = shell_output("#{bin}/chisel #{which("python3.13")} my_script.py 2>&1", 2)
    assert_match "[Errno 2] No such file or directory", output
  end
end
