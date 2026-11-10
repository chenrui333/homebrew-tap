class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.115.tar.gz"
  sha256 "a8451edf5d702b42ffee6c6fed6ff9f1721d4f03745be9c78e2b769e0398e1f5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dadf339cc848b09357d6f387b2928b1f8bad38dd0dea7bc77205a9bed07c0043"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "399aa7c2b63a80981752ad7ff20f4d4fd00f4255a9b00f77cbf2e2107b3ce37f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "251d64a0bc6f6406dceb3a697ad5d58600121b39911ee93888d40af22d616786"
    sha256 cellar: :any,                 x86_64_linux:  "ff9526f5fe64a95bd448f230ad7996c9aa030c3c30c7c1300f50b5317aa1e7e5"
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
