class Asmfmt < Formula
  desc "Go Assembler Formatter"
  homepage "https://github.com/klauspost/asmfmt"
  url "https://github.com/klauspost/asmfmt/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "4bb6931aefcf105c0e0bc6d239845f6350aceba5b2b76e84c961ba8d100f8fc6"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f310a144d5e4bd09618f46dd631f377b5102b71a72e8895fc136e40db2355db4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f310a144d5e4bd09618f46dd631f377b5102b71a72e8895fc136e40db2355db4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f310a144d5e4bd09618f46dd631f377b5102b71a72e8895fc136e40db2355db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e72add7be6e546757dc981589577eeb0d9c981aa121b656bb20726da366d9eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9de37620c2b3b52038453b16c22e5cfe8c707f90c70ed9b9047e2a610171d158"
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
