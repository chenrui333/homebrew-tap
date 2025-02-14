class Pyment < Formula
  include Language::Python::Virtualenv

  desc "Format and convert Python docstrings and generates patches"
  homepage "https://github.com/dadadel/pyment"
  url "https://files.pythonhosted.org/packages/dd/9e/c58a151c7020f6fdd48eea0085a9d1c91a57da19fa4e7bff0daf930c9900/Pyment-0.3.3.tar.gz"
  sha256 "951a4c52d6791ccec55bc739811169eed69917d3874f5fe722866623a697f39d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c04dc0b9bf95d88b54b15af0070d7d473c09abe345f9c62935a73630192e785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b136efd1f1c5ca9701e18ca7e8fae64a31b73414242a65abc82fa382e6b39d"
    sha256 cellar: :any_skip_relocation, ventura:       "918895af9f94f2257c49b36be68d1e4eb21035a664f894649302a7b5ff8668da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e182f07e7bf066fea3c847171f7c69e04f5816144a18b40d724fd6d2e9b4d6ba"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyment --version")

    (testpath/"test.py").write <<~PYTHON
      def foo():
          print("Hello, World!")
    PYTHON

    system bin/"pyment", "-o", "google", "-w", "test.py"
    expected_output = <<~PYTHON
      def foo():
          """ """
          print("Hello, World!")
    PYTHON

    assert_equal expected_output, (testpath/"test.py").read
  end
end
