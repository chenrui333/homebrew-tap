class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.117.tar.gz"
  sha256 "fc1018ead7b1dd8b975519ae5b2b021eb04a076d843a4c104404194be748d4c8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7386acd332feebd33d5ccb832b01ae8d947ec3b3a1c5dd29c8bb5ec63e8f8ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45c6df42e8a55677b5d29c1911d77acc1783700c0a0b22253ba061f552c25e45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "276bfa6e14fdcfc8ccb3058f2c228e43a1b8e56498b6271a502c7d5810245913"
    sha256 cellar: :any,                 x86_64_linux:  "bdfc014606b72df8e58973d8bd39af930e0787826189857176cd87bd6d99519f"
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
