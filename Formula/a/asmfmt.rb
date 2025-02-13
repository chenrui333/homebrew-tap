class Asmfmt < Formula
  desc "Go Assembler Formatter"
  homepage "https://github.com/klauspost/asmfmt"
  url "https://github.com/klauspost/asmfmt/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "4bb6931aefcf105c0e0bc6d239845f6350aceba5b2b76e84c961ba8d100f8fc6"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/asmfmt"
  end

  test do
    (testpath/"test.asm").write <<~ASM
      TEXT ·Example(SB),$0-0
      MOVQ $1, AX
      RET
    ASM

    output = shell_output("#{bin}/asmfmt test.asm")
    assert_match "TEXT ·Example(SB), $0-0\n\tMOVQ $1, AX\n\tRET\n", output
  end
end
