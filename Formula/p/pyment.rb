class Pyment < Formula
  include Language::Python::Virtualenv

  desc "Format and convert Python docstrings and generates patches"
  homepage "https://github.com/dadadel/pyment"
  url "https://files.pythonhosted.org/packages/dd/9e/c58a151c7020f6fdd48eea0085a9d1c91a57da19fa4e7bff0daf930c9900/Pyment-0.3.3.tar.gz"
  sha256 "951a4c52d6791ccec55bc739811169eed69917d3874f5fe722866623a697f39d"
  license "GPL-3.0-or-later"

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
