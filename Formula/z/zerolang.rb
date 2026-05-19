class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://github.com/vercel-labs/zero"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "0e8f91f9e5abc490488504f7e878a1b042c6dd432e693ec3bbcd5acb248f83e4"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e99af2f9a6e12b5107965761d1cdbd5ebd29c5b2bf33d0e4d91fae4b060708ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1a0327743c945a0dfb37c2cd54349794b971a52a18db48875eaeca195bd8a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e0305d512cf287bdf66b910cfca862e2db24f198e8189febab4b384a18df19c"
    sha256 cellar: :any_skip_relocation, sequoia:       "db2049bc30fbd5bd14c203aafe6840b59d790d3ccf3a0c58be0be8641676e77b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "390fefd47354a56e8fe690b223cda18796614ec79b82f40ddab13419a62f6e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "562cba41de5e9295c109ef4a37c9e319f4e44b99f8ab9a57c9addd871e03bbda"
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
