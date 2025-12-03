class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/6f/9c/6f2266347cd0f44c942590e1181cd64ce98e1aa6d49c0060547e6c4e0c25/ty-0.0.1a30.tar.gz"
  sha256 "24467375575a3d6ac7fa4b2daaf29f1865e8846144b13ceaef99fd3d969efcff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61965658d835b9fd6a75bff8799706d59cc57b7294597c33ff41f54ce23cd0f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d43d4cce0c95c39d9912bb6106dd028933c4432f47b6ace576a3eab99fc817fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55606ce9ea2bf1821cd3d7f659df2d9428a450d3c99c45909d4a9626844fe41e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c807e7aa106239268452b591e840b9f8abb691f3bd9d5d114f237cd42a75c1de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c97e5e56b4e9520aaeaeb68f3bad6b513c9c6e86701488bd119e814118c85c1"
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
