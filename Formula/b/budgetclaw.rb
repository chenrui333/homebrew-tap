class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.132.tar.gz"
  sha256 "8acc25028375941cf53dc1daabc2ac427cc797cff05c639aaf759c1909598c59"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "8e964f005f3d7acb798e90781cfb1be75175ff86710424a07f37d2dea6c6281d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d296a3dcfd1c4fa185ed455ae445b82d2fcc7a48caea43d1a922d7e36784e1c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e87807da51235488981618c1a262ce9b87d77e3eb3e26743bcd632175209c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "face23b6bcfcbbcfbe1d8bd74c58b2cdf1a801ea09c8eb39e5f1d01909a26904"
    sha256 cellar: :any,                 x86_64_linux:  "82a8fc7c598769a31789629d9b37e96c26ff3c37b87ec337fc6459d2c4a0b5de"
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
