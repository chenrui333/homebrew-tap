class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f5/f9/f467d2fbf02a37af5d779eb21c59c7d5c9ce8c48f620d590d361f5220208/ty-0.0.1a34.tar.gz"
  sha256 "659e409cc3b5c9fb99a453d256402a4e3bd95b1dbcc477b55c039697c807ab79"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bb32810fe946e7814f9202eb475ac1199f2ff0acd9751bbc10189b84c9917ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a22e43b1791681fa3630c9aecd8d29a895bcdd4ebdbf0331da9fe8f635125e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42dc2d81d3056090d0a619864b50389f233ccaad1c5744ee0696d0072d392f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f89b03f60c4d64a4b3269c493b4e8c32bd7bd0d1bd26409cce79a565326458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f00a893e0f970539450bd1824f7ef80da5f009fb863dc76b1cb02f0a5a36604c"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
