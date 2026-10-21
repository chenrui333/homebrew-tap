class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.89.tar.gz"
  sha256 "bc39f2005be1278892f464daf423619b792fe9d531ad1eaa62d7373f9583fe1e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e603f64c9fcd258a0512f7da8859e4e88d0c0f7ec812075ec9e9d7cc1037bb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db294f411a25d2e35ae5e01ff2869ca1cd98677b359c983d4a9a822d551b69fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17650fcc4db3d15a779406c1f58bdb3959cf781affffb97773868b732e1a77f7"
    sha256 cellar: :any,                 x86_64_linux:  "8e4a249f7a20f2433431471f2c9349ae18e6864d55908509cddd2ba61100edb1"
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
