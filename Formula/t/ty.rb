class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/82/e1/1a75c95fbb284954b2f6fbbf7fbf1d35f531f50ebe93b23cf53145d1bc1d/ty-0.0.1a29.tar.gz"
  sha256 "43bb55fd467a057880d62ad4bbb048223fd4fba7d8e4d7d5372a0f4881da83fe"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fe66c93463c13ec5f09a534eadd714977c23dfd341d5caf7592538ff06e2088"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b251d897d5f5e8eac658b3e63ce53117bee9ac0d9692d0d5162229b8e0c07020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52193bd20cba9d14694329e1ed49433ffe9b026916b96db4889f3eddfdf922ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28bf0ce68f80ad9673294fb9b4fe3fefda47a0d5ec0d016f3351baa245cc2616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18712cf4f3b0703185720327bb07db1d5fd81c3e2b4ff0639869e2b6049de0db"
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
