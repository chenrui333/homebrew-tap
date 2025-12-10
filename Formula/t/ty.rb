class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/60/34/82f76e63277f0a6585ea48a8d373cfee417a73755daa078250af65421c77/ty-0.0.1a33.tar.gz"
  sha256 "1db139aa7cbc9879e93146c99bf5f1f5273ca608683f71b3a9a75f9f812b729f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b51dbabdb4f1585aedf63501efbbe1b06d6263488388d4d39cb41388bd960eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "139237e0122942fe904b7883d79c2a935bd0ae734473a0044b4f71767625b93f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46b1cf7125af0999ce5b1751bd292b97bc48206ea2d255817bbe662a57492ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb7fe554993cd578c20314a1157ed05faf3607175027ae53812ecf03589aadba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68834c29e77e21228adf6aeb243974c460b1daef173555c82ef14b73835022c"
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
