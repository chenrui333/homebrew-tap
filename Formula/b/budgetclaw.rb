class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "26c3dd19ff4d641825cee3a0bd3b5dac9b0e9c8e90807a0ed0a16e008b3d8f1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17bb13ba3e37c18c78c34d943c578258c4a71de458780dd60dcaeae934e312fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c259823278e0de44fd76b3662de0be62dc97c2b0a71c1971e3c65f7aea8e660"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47156c18444ef3d5953db02dfa578fb3552064047728ac4467515077dac33f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b37fddadcb135f00a8e99322e89af9a62e7e0062cb677d97f68cd1eb3068f6ee"
    sha256 cellar: :any,                 x86_64_linux:  "61dc402b8a8240b5ecbc6e3f6c7de7c0cf7b6353186a9ececc2304d1df743f4b"
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
