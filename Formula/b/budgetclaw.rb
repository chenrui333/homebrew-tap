class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.76.tar.gz"
  sha256 "02491ba8118471028c853ed29f678d3bd8e8ae1d7bb2e55e8eaf5475735e7d19"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2cabc59bdb56c34c5f1c3f12b150bdd9a812f32bb1bde1db72008f0ab3251b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8d8d9aa57e83dc6af5e00a567d72ce44e99c2583fb4971c4a2bb005666f0353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "966f1c154b9e6587f43d7d63e9f89fb40fd80117b988723b0f74d17dc02f4468"
    sha256 cellar: :any,                 x86_64_linux:  "9f871ef720d249bc636493f215b1398ef60b7ac1d2ab94137f6771f985382035"
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
