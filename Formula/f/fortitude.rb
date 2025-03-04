class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b350901db0536d73ff9b5ebcf1ea58ff7fbf547bd593d2955f5dc3363c0bb736"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e00b3614b17f8a9bcff81e117c174defc6fdac240599d9c75d49ba5463227c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5a5aa331f15583416f4af47c6aba33c2dd076e252027a7c44e3e124bf52f9bc"
    sha256 cellar: :any_skip_relocation, ventura:       "c972bc580a18054387965d7cc9061363456eb97c2f6089ff2c4378ec6c0a7953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d85bb790364e7fedec53734a90bc748c89ed94170ad2b6b7bdbb64b57a2534a"
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
