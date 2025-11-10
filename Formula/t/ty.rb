class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/39/39/b4b4ecb6ca6d7e937fa56f0b92a8f48d7719af8fe55bdbf667638e9f93e2/ty-0.0.1a26.tar.gz"
  sha256 "65143f8efeb2da1644821b710bf6b702a31ddcf60a639d5a576db08bded91db4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f92d3259435bc548f2902a074b716e300f0607ad24cc5595ae698d5bee9e3ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3172211b0a6ecc2bf96c7de5f40fb1037444ce5dc82e8fef4ee240818d6df453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72c7e9ff9d5fde29cc9fd6200c4d43188bd0fd1d7ffda4392b1728fd4afdc75b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed64edabcb4950a9ddfc454dd974dc58a303d0d788940cda9683c9942269d8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c7b423b763f38b88779e2166788e3dae5cdf1eccfbb3b0f0194b45d7c813ec9"
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
