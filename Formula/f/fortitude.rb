class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b350901db0536d73ff9b5ebcf1ea58ff7fbf547bd593d2955f5dc3363c0bb736"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9be8ba01422b78a106bf3fdff7efc45f9087fb3ce5f0dc712dae3c60bc7dca52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c4778ab24109fba9807d61255997035f30229d22e3d596e0b4e1b1f09c0cb79"
    sha256 cellar: :any_skip_relocation, ventura:       "c026c0ef63313b8cd7c47376127d72790ad9869bed2ac124cf98c8564dbb4741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2f53f1996ab23966e093bd87afd7329bbbf376ae1493b66aaa8981bb7c6d595"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "fortitude")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortitude --version")

    (testpath/"test.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    output = shell_output("#{bin}/fortitude check #{testpath}/test.f90 2>&1", 1)
    assert_match <<~EOS, output
      fortitude: 1 files scanned.
      Number of errors: 2
    EOS
  end
end
