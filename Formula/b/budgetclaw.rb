class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.71.tar.gz"
  sha256 "4231dfaeffba1f3584eb1569f45f3eaa4df709d8579e258f3a9f8459fd7a0c3e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45286a35e8adfdf34d8cfa6f8fb8a3e640ef84c1174286f6903bcbc4777a9926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89bea577e3dec90a17373f4543ca801490654892efbcffbec5a00aeddaacc291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2a1883a681ecdf8a684159d8e0782990317187233238d60e64f4dbd9fa0c379"
    sha256 cellar: :any,                 x86_64_linux:  "d52070e87428e8d6cd74016eeebfde6d0899f6fa47c027c329f2c5e56b56a16c"
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
