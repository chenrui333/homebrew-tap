class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.128.tar.gz"
  sha256 "022d8ddf306f82a47fa5d0ed8af4230041f7154a08b5b719e4b80c2ce57783a6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e70d7d5f81bdd9a5d3c4f7acb418d2a55edfd5ab5312975e70be9e44330eb372"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73082559f6d8c50b53ece0136a0462542a7ef8878edcc92027f29b19c648dce8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de6b36d02d8d80aab7ed6b1db01bcf0aa18748e42bab07fef02641cf08d83c1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "167b89e62dbfbf7fe90c49eda8817af6895e9b95a5aabf12819f216610966751"
    sha256 cellar: :any,                 x86_64_linux:  "0783531a45c2472d146a18a7b2293a7da005368a861a48e3d1fd8e635e75bf0c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
