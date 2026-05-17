class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://github.com/vercel-labs/zero"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "69b914820adcfadd2a7b675d429fffc5e74602ceed555082b8406feecd77d653"
  license :cannot_represent # https://github.com/vercel-labs/zero/issues/36
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff8adbbfdfea7a03ba7a5308198a0e1765f1055be57990e4dd97c265e5b94a43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9321c31899ca828c4aa02315165ca4ab731c4bd6381d4c7dcc4a5c7370b3494a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e0bf1c053d78c2da0a9609f2a8a6da64a255283dc6f750627dc6a789a2612e"
    sha256 cellar: :any_skip_relocation, sequoia:       "37b5778672a144a4ac1ebc16f92e7893090b71238c147edf16fe25eaa9cd9bf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98a6343c0d6017e915881db809754c392d47f234877ac95250d23e9865b85caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8bcc12689becf55eac631fe54efa2fc33309717904afca8b4b2a0605c60f3c"
  end

  def install
    bin.mkpath
    cd "native/zero-c" do
      system ENV.cc, *Dir["src/*.c"], "-Iinclude",
             "-std=c11", "-Wall", "-Wextra", "-Wpedantic", "-Os",
             "-o", bin/"zero"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zero --version")

    (testpath/"hello.0").write <<~ZERO
      pub fun main(world: World) -> Void raises {
          check world.out.write("hello\\n")
      }
    ZERO
    system bin/"zero", "check", testpath/"hello.0"
  end
end
