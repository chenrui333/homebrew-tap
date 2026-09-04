class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.43.tar.gz"
  sha256 "72f60e67a63a911ac876f4a940d7ff1f0ee4bc97ae04317e1adfc04b17e634fa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13eb0939a6dff28dc62a92d4f7968685a106c6ce4816fa528116f6cc6bfcd6cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40fe52c4ef9dc4b928836c25fd4cd41694560344a46132824744d3c34391eb79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6625c61c0cae6991e2d31edbde5c3c1ae0e95270d4e527acc47d629b0a3fb2fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19856413598b132a313b99dea747bb0557795b172d278e4fd5c37174e654d6ec"
    sha256 cellar: :any,                 x86_64_linux:  "3fd0f94894d6e96a96a5571d122df0e8dc034c725d28fb01b6dad52e559206eb"
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
