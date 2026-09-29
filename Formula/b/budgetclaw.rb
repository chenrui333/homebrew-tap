class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.74.tar.gz"
  sha256 "9852dbc55919915ce3812b72d0cbb27fd4813388f500b4aedf6a2295c141635c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a01c0f3142ace1f2b80e546d4435cabfed1413e915940f5bea47801a2b988462"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "607e771118a900622b99145c6720c7caf2ff94bd3860f1ec78355106a0104cfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f74f90021ba8926412ed4d2076503758f334877ee1e04bf2b37a3f39f9d3ab"
    sha256 cellar: :any,                 x86_64_linux:  "6e37b68219a0b8702d48be9e5a3b7a9028ffea44543f54b4e6904ec59140c034"
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
