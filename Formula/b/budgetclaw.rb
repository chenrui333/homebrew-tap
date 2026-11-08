class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.108.tar.gz"
  sha256 "e008e19978474a9b4bf65ffab0d00ce2a6b4cf84925039c5652ab25659af3cbc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bf136e1452813b543cde3171bf9635fbf25cf54cfb10c61b3502531918af55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc9ac7554c37dec658acb6c9c3999aa8f20fc43a79ac6dd2ce5943970e99ee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a09e1b39040639c997b6961133932581bd7e080ca2daf4182798897d2ac98831"
    sha256 cellar: :any,                 x86_64_linux:  "5919abb96c749705c65f7ec7a3110a251707cbedaf35f1fa8014fdf8c633a8ef"
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
