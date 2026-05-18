class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://github.com/vercel-labs/zero"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "69b914820adcfadd2a7b675d429fffc5e74602ceed555082b8406feecd77d653"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b5466f298363ca8a278c76a723a6feb78747f7f508246c2d86c9daa2c8f698d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62f6544019c4cfeaf792d1a4a1e47a0bf3a9baac57921bb4d7f814e0b9340bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d04c7de5cb1b6a9f3ae891c4d197fa30132e323aabb653d624661a12b905f1e4"
    sha256 cellar: :any_skip_relocation, sequoia:       "d6c59c30cb310e6a19a630aba7832401295c6a6c1c40eaa31e60aee9bcebe2e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8832ba3c8bba0662f5e3b7cfce2caa498c9634c6553d7747f132a889ea1a3c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05e344faf31a0b4146a3fde53c0f81a1c74e7f7207624f3f5e3c1ee9a5ad7a72"
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
