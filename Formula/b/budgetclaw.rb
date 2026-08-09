class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "80803134e85710f61da22d05e7e2c88de977be7d0b2c7104300e65de428a2336"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70a8ebc425e9a417387c22b93307df7afd8e6e8abf860cc578c12f3a1afbefd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac010a39ccc96e3d84031fc0408d4c4fd452ddef4196311c771202e86654e6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11aa444357ef993320a1e7395c4995c78d8be84781c28064f1a5c922ae5fd605"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d1f11ac7a09e77330a8f5a5de64b256fa3dac80878699623e21f61e23c1b62e"
    sha256 cellar: :any,                 x86_64_linux:  "31331fb507cc4e436e56f25388c44763f3928d3ad79c404a1c518223513ac604"
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
