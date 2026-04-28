class Autoflake < Formula
  include Language::Python::Virtualenv

  desc "Removes unused imports and unused variables as reported by pyflakes"
  homepage "https://github.com/PyCQA/autoflake"
  url "https://files.pythonhosted.org/packages/2a/cb/486f912d6171bc5748c311a2984a301f4e2d054833a1da78485866c71522/autoflake-2.3.1.tar.gz"
  sha256 "c98b75dc5b0a86459c4f01a1d32ac7eb4338ec4317a4469515ff1e687ecd909e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa580164bc7f251a77a0113873b8f6cf53d6e16d4ce639778ca9023b39968b0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9e1315e69e97d7ef06b2f7308f1ded722aa8a51a6f27dff28f9def998d85b57"
    sha256 cellar: :any_skip_relocation, ventura:       "70d1b2b0c56770df24cf746e5dc06fd1dff6993ae490bf13a360a5ff6130ea3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9baad05efcc1b028d1bc73645214c32ceaa7e2c9529b6e13b99e7e04dc27c96"
  end

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
