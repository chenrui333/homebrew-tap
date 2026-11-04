class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.100.tar.gz"
  sha256 "4cd249d6950b79859dec91075a4aa42a3d58637d600240e94b976741c54b9c75"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a9f372d11a05a96361ca7b7ef7f7f0fc1b5d19d3eabe8a21eeb23d4957f7edd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a571aaef8192f7153962f14cf058d30a6bf2214b0907867eb4ae642e1801f72d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4d40a53912492ab81066d5763427f814ab206dea1456a33834e55e601abbaa8"
    sha256 cellar: :any,                 x86_64_linux:  "cec3bf32ec1f979320d17643de63521706f858d0a09a486907c3db8bdb505d6e"
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
