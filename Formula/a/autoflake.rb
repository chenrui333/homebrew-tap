class Autoflake < Formula
  include Language::Python::Virtualenv

  desc "Removes unused imports and unused variables as reported by pyflakes"
  homepage "https://github.com/PyCQA/autoflake"
  url "https://files.pythonhosted.org/packages/c6/f9/742e1ec86d55869cf003f8bd058e559a9726a0afdf1d5664bbc8880cbb8d/autoflake-2.4.0.tar.gz"
  sha256 "ef7c496d9bce9d2cef049f24e482d1d3090c37fbd44e5e85dfb00db3c78ee16c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "400f55a8356b437c8a856600bdc6d6a6e9fe3a2aab60096ae7e4e1368a2cee4a"
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
