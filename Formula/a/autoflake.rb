class Autoflake < Formula
  include Language::Python::Virtualenv

  desc "Removes unused imports and unused variables as reported by pyflakes"
  homepage "https://github.com/PyCQA/autoflake"
  url "https://files.pythonhosted.org/packages/49/48/bc1ac8a8c33611d43e84fa7c9c4e0c8a9152510a9ef79c04957024842d2e/autoflake-2.3.2.tar.gz"
  sha256 "73d3b22bad89034879f7a4871c279c8d189b3f2c0b9d9e274b8e5b468c17f9a0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "503f24fde3a52c2052915be7f081e37ae013b08d66acc98ff629997bdf1d368c"
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
