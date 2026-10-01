class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.76.tar.gz"
  sha256 "02491ba8118471028c853ed29f678d3bd8e8ae1d7bb2e55e8eaf5475735e7d19"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fe155280a824623cc9933e42ceb9e972cd17669f26aa667de25634caa2f7134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dcda6ed686737ac06fb1c7ade68e05185882fe837c2335d43179597077a9495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31f66ae9b5a7c97b8d3f2b5a2069cbd905ecdc598d02cfac613a2325368550c7"
    sha256 cellar: :any,                 x86_64_linux:  "4685c2cf211f03ca3fbf9d3e4045fd24230ddc48c960b747fb52603e10fffd8a"
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
