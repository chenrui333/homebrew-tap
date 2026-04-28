class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "59f19accd26a759aaf80237258ed7b0b92fe4980e592e36d752eca3458f985c9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f2aca3740454cfc12744d6d1eda36a7a720798e21d6f5e9e2d8f64197b051da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80ad9640b2aa05160d1d3002bfa9d49abe010eec3875fe044c80319875077796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e6da06241c1d9b9b13ea77ff25b38ba7ef17a2b847d30f88097782ab586249f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "765bca856f96426f1ff5e924dc9757462f98a57c8ce3c1e51d9985449bdcf0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eaa96de7cd682d85a6249ebe6a36212eca563e39edd3d4115e7385f9c4a00d5"
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
