class Jaggr < Formula
  desc "JSON Aggregation CLI"
  homepage "https://github.com/rs/jaggr"
  url "https://github.com/rs/jaggr/archive/refs/tags/1.0.1.tar.gz"
  sha256 "3277e0b459cc5930e504faa8719c61327fd69c4f840bbc6a08ddd78f6f0e8c0c"
  license "MIT"
  head "https://github.com/rs/jaggr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8308d1b6e54cd996ee0229d48bbaa7d9ed6a4bfacfe183331d0081dbfa23d4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8308d1b6e54cd996ee0229d48bbaa7d9ed6a4bfacfe183331d0081dbfa23d4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6778aed748b2749c285ad578a49bff333405e54e70d5cf76f88b6e0ecf8f5e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b370e88d551f09a8bb06e58e5b4d93640459ab5511825941425b34dc89b798f9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jaggr -version 2>&1")
    assert_match "invalid input", pipe_output("#{bin}/jaggr @count", "not-json\n", 1)
  end
end
