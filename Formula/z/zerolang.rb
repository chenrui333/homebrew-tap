class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://github.com/vercel-labs/zero"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "69b914820adcfadd2a7b675d429fffc5e74602ceed555082b8406feecd77d653"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05ad97889c643ebd6c4ad18b2dc1725a3b700f94dd518d030107f1b3f065ff44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37cc59ba7a5d3b79ffa80ff6f48d45a8c71c6a0ed020eeb0a786dba520a73bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca30e1c35d70370f8755d3140c3ecf858b6cd78bedbde5519aad2865a2762a7c"
    sha256 cellar: :any_skip_relocation, sequoia:       "80ddbc3954655b48d1d75f1b46c6e5165769520879713f32e12d3c2ec449d8fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "683925ef21ea5bac7b445185cb97bfddb0993cb705f2dc12fd907866d52b89e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e58a70f842db49ce029ecc2ba8a0157d186ed9b7158b8e88e4c429ac6a9a9a4"
  end

  def install
    system "make", "-C", "native/zero-c", "OUT=#{bin}/zero"
    rm bin/"zero.build"
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
