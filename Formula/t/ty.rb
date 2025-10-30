class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f6/6b/e73bc3c1039ea72936158a08313155a49e5aa5e7db5205a149fe516a4660/ty-0.0.1a25.tar.gz"
  sha256 "5550b24b9dd0e0f8b4b2c1f0fcc608a55d0421dd67b6c364bc7bf25762334511"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b1df7e8476879fdbfd0621f6229f0eca6c02fa3d993efd5d369ff99dd896ba0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f32f43b0c58064d07fd68a6a58e2812ec59e5c0aca668a3c945c1ff79640b0a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9cfe299ff516209d38afee81510b0fe1bb58c6c7621eced7e07f91e160e8edd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6931469e9a86cb42dbed598f702febc027aaffc4c9a2d95c8592b302c644553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de39e9a5a723af4cf72a1953a5a5b0343f980aa08472780bcda864a02d4c5202"
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
