class Autoflake < Formula
  include Language::Python::Virtualenv

  desc "Removes unused imports and unused variables as reported by pyflakes"
  homepage "https://github.com/PyCQA/autoflake"
  url "https://files.pythonhosted.org/packages/c3/0b/70c277eef225133763bf05c02c88df182e57d5c5c0730d3998958096a82e/autoflake-2.3.3.tar.gz"
  sha256 "c24809541e23999f7a7b0d2faadf15deb0bc04cdde49728a2fd943a0c8055504"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0289b08fecd545e4b33c179dcd8f4767e70ba7cd89ab8ca7f2c357f27d96112d"
  end

  depends_on "python@3.14"

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/45/dc/fd034dc20b4b264b3d015808458391acbf9df40b1e54750ef175d39180b1/pyflakes-3.4.0.tar.gz"
    sha256 "b24f96fafb7d2ab0ec5075b7350b3d2d2218eab42003821c06344973d3ea2f58"
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
