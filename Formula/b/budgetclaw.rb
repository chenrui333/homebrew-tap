class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.123.tar.gz"
  sha256 "97a32ad244fe4a9e2e3fe596942303acbba771ae3e35c682b27fb08a955d11e6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7de23b2ee19ee3898b6057b2f2772781b7d2c65bd401d8645a77bba6fafca3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41c9d8bc97f1a4a1b951029f27e23f97ea5388d46cc63d6b0b4589e5375b7a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfaf07b5bd7f0b2741b1e89ecd2ffa29f831606c3de7ae4a4234d9b9b6364726"
    sha256 cellar: :any,                 x86_64_linux:  "fbbd5ec49b6cef2843d1a4fa96d348076207b6d5d2bb1d394e3e2a1102f0c1a6"
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
