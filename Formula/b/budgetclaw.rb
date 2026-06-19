class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "e906ff66ae1c3063e2efa24091253c398c901d467f6d4fb526ff27a5b114f404"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46eb7ce429fd810b1d2ae9bbcce8f28092d37392b78fb26ea633f527c82ae283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3186c958e33469cfc6b7499a07a034d3fd4b68765c75838ab84e4682cc6a1870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0e87023a11f79df6205ad6cfc67627bb3f99e985ddb3eec11673e584c287db6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f475121c75acc2296e3713ad2cdd1e06f2b6b2864d6bd547c80258e54e0f94cc"
    sha256 cellar: :any,                 x86_64_linux:  "43fb3a9b7615bee85330f6095820aea528122ba4f4980b0d88bd6a91c60bf925"
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
