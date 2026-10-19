class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.84.tar.gz"
  sha256 "5517702182a9480e2aa95e571ea35fe5e9ea25fcc40865d1738ad11d46a8aa42"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47b2d03681a539058409678cfb7e1128166c8e3ca9e2d33958d89e571d04c9de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ec833fc6ea07084c6c1e4048f0731fc037c943c36e7c52fc51a9b67b759c4bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfac329e5be548555df4cf013dd9009bac42fe4548612587a0d95da9ad9ff033"
    sha256 cellar: :any,                 x86_64_linux:  "e174323874812520a05ecbe5023ff7da8cf4844490c330030d5bd2633976abe6"
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
