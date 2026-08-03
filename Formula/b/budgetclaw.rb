class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "005563c38e589449e9be70ed70729a5556931e19d5be872044ae5af4310f88e0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f62d2a9a2e0d816397bdabee2f149c0a748c414d039ce01f09908536d020f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e64aa4fd4743cbbd5401f7b3b7eb3ee7eccb02e465522dca1659c9b74e97974f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d221e99320987769f2b8b011703dda1a735779d71c063f81c31ca5cbcbf20f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "587218016325943bac56db5d7a9873f2ea9346b21248030c5c007cf5d88579f7"
    sha256 cellar: :any,                 x86_64_linux:  "e922beef9ff8ab704420f4bba369849c2bee2a3affeaba8e20a7db2562fb0cc8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
