class Refurb < Formula
  include Language::Python::Virtualenv

  desc "Tool for refurbishing and modernizing Python codebases"
  homepage "https://github.com/dosisod/refurb"
  url "https://files.pythonhosted.org/packages/a9/83/56ecbe3af6462e7a87cc4a302c2889e7ce447e9502ea76b7a739d1d46123/refurb-2.0.0.tar.gz"
  sha256 "8a8f1e7c131ef7dc460cbecbeaf536f5eb0ecb657c099d7823941f0e65b1cfe1"
  license "GPL-3.0-only"

  depends_on "python@3.13"

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/ce/43/d5e49a86afa64bd3839ea0d5b9c7103487007d728e1293f52525d6d5486a/mypy-1.15.0.tar.gz"
    sha256 "404534629d51d3efea5c800ee7c42b72a6554d6c400e6a79eafe15d11341fd43"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/refurb --version")

    # Create a simple Python file to test
    (testpath/"test.py").write <<~EOS
      nums = [[]]

      if len(nums[0]):
          print("nums[0] is not empty")

      print("Hello, world!")
    EOS

    # Run refurb on the test file and check the output
    output = shell_output("#{bin}/refurb test.py 2>&1", 1)
    assert_match "[FURB115]: Replace `len(nums[0])` with `nums[0]`", output
  end
end
