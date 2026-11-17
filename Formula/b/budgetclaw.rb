class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.121.tar.gz"
  sha256 "26e36261e2ba71898821be4e2e059450975116dc8c880eeeda03245e1b7aae36"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "944d5be9068436bcf3343b1642486e238a946b55dc68a9853394fec6edf82732"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a877a22ce18ebc01b72f82d6b9a6f977475eb22f911f4415d2f83fb3f21c6ea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85b4d8fad970f42a7657d9da28b5193edc870cc9f5b6160fa028b660f06db2ff"
    sha256 cellar: :any,                 x86_64_linux:  "34d6f947bfbdd0777c76b234dedd0383b8f8cafd800d9cb4887323830c15e03b"
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
