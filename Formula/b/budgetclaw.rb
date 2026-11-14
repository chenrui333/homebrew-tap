class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.119.tar.gz"
  sha256 "c95cbb7fac0a7acc9d55f12a9be21d4359ad53a18cbede34de57a732ac2e9669"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e133ec96490272d7fcd584bb7833e9e62c0d81595bf5a4246aa0da38343f24d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae358c6e814cca1b6fbb3ff772366078410ea3e2c47b373ebeca28964e1c7bf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f4143e59d6593cfe7f537e669824586a7182e4489df8a25565e7d037acdbfa4"
    sha256 cellar: :any,                 x86_64_linux:  "bc007e9ec6e41a0a071a57545ffe318f8cbbba92926444dbf246a657c71c1ee1"
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
