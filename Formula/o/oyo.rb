class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.43.tar.gz"
  sha256 "4e162020f21508aa5a86201e0421d18c9f49343c5e0476ae265d9cdf4ccf3936"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edc888e914040727f176815e511196fd4571d7affb385a263f43d32aacc0c4a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4010e8cf0dac42f2265e6f49725e3d55ec0b2d695606a3b35b54958ae235f07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cea88af89e2e85ee58f9c4e22d8644d51acaaafac67aa6203982f2a02129495f"
    sha256 cellar: :any,                 arm64_linux:   "6a6f37c2f7515b4ef81d1cc8764bd71de599294e2723530f42524d4e49a6ddb4"
    sha256 cellar: :any,                 x86_64_linux:  "d719f2ce450513b3d6f6d2aea04f1a3f7d1dbbb5b58a97456f5b20b6311944b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
