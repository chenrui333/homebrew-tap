class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.120.tar.gz"
  sha256 "951e4ae6ab7fd01ec4af0a681d3563e31eace8a74adc2fab4f7a8a350ab7b73b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "792cd5e1a9f95b1cdf975f308297cdbe60ca22bdbcd260bc16e422eb1b326b29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2adbe8378c8042eea9c0ee675d8585a593bb51d0fd8375d37755d1b2db60f780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1fbebae8bfe668f8825add5afc8fed609b8f4848fbc7102f09a39a15a5cba10"
    sha256 cellar: :any,                 x86_64_linux:  "79adbe3a30dbf6251fd8c7c4ab03828f4b7339cb9b286ecc99c570c74583a79e"
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
