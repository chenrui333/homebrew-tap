class Asmfmt < Formula
  desc "Go Assembler Formatter"
  homepage "https://github.com/klauspost/asmfmt"
  url "https://github.com/klauspost/asmfmt/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "4bb6931aefcf105c0e0bc6d239845f6350aceba5b2b76e84c961ba8d100f8fc6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20383fb7390daf782baec428f06559feb79550eb0aca0406b24d0e5fd0b61501"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d969c7ae2c5f634bba66267b11cd402e02c490640479556a935b6ed56b88ea36"
    sha256 cellar: :any_skip_relocation, ventura:       "73d0bffd8e9bff94127b6467e0322ea88ddff0f442e52de9478d697898fde968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f7c91a5f5009a39df2be9d07c99e6cd4927e17ef1b2499566d36db51715289"
  end

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
