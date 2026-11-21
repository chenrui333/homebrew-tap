class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.125.tar.gz"
  sha256 "540a456826afe3c7ee371a7df4500081c39d0cc9debb64fba83b86cb80ae0fe9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff8026780832f908f2b42b260502b51859f8eda5209b76847c1e5ff5732e41d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "148e1b157dacb49e6cb87ec37b6a2ce6027dbffe01873172511350d58e603f8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3eff5505271da2ecafea5e494353c91228502645d199b73ecd733709d4714bc"
    sha256 cellar: :any,                 x86_64_linux:  "bd5d05e3e988550292c40f3f9c01cf29a8d1fda006805ca59972efb7abeb7a3a"
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
