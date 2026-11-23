class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.127.tar.gz"
  sha256 "82b5e18cc8f0cee7b675b682015917accf551588fe17b9742152d97eea4d3f1c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "1818809662c6a2ab84041abfd6d4d14a4a036905aa7c65a8e61e0920c2adf937"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "743125a4d39e2e0110d803e6d9a5f34ab04fc7189a2ae9ad3eb5ad20d0bfaf46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93543967e69e64d3464ae88c2a5aae3e645ec406ca76c61cd01b357733772e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe525ce9756370dcf37b5cc8eea6ae7e4a5b8e0e98716a93c22f6ce01174651"
    sha256 cellar: :any,                 x86_64_linux:  "3c3300213093b6d97f94909d0cb430ef82d0b46aa994577966c2784506f5caa4"
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
