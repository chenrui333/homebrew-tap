class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.112.tar.gz"
  sha256 "4192e7aed6fc0ea4bc63fec31cb7daea27525ef575e0270136632804719f25a7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2f2707e82b6333e1f9b72544929a39f60477b61c61d0441a638679405132a28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce68a3cdb4d4bb003e7585f145609729becdf7a02a4ee7fed9dd7c5cee8fe028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fb17cc6bcc6eb881a69be943da5e6a0481d8cf8ae281d2e6c1a2c20e9226f57"
    sha256 cellar: :any,                 x86_64_linux:  "afbccc4a5b8563d7963c32c2e07ca3aad779d6b8c8d95ad912ce42c9292a8e04"
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
