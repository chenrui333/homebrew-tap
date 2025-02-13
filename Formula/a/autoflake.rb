class Autoflake < Formula
  include Language::Python::Virtualenv

  desc "Removes unused imports and unused variables as reported by pyflakes"
  homepage "https://github.com/PyCQA/autoflake"
  url "https://files.pythonhosted.org/packages/2a/cb/486f912d6171bc5748c311a2984a301f4e2d054833a1da78485866c71522/autoflake-2.3.1.tar.gz"
  sha256 "c98b75dc5b0a86459c4f01a1d32ac7eb4338ec4317a4469515ff1e687ecd909e"
  license "MIT"

  depends_on "python@3.13"

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/57/f9/669d8c9c86613c9d568757c7f5824bd3197d7b1c6c27553bc5618a27cce2/pyflakes-3.2.0.tar.gz"
    sha256 "1c61603ff154621fb2a9172037d84dca3500def8c8b630657d1701f026f8af3f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autoflake --version")

    (testpath/"test.py").write <<~PYTHON
      import os
      import sys

      def foo():
          unused_var = 42
          print("Hello, World!")
    PYTHON

    system bin/"autoflake", "--in-place", "--remove-unused-variables", testpath/"test.py"
    refute_match "unused_var", (testpath/"test.py").read
  end
end
