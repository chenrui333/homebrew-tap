class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.75.tar.gz"
  sha256 "cb69fb8ff03944eff86d5d1ebcacc103d1c79fd7e0f9d5ef0bbbb499ba091629"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7198bbc29f5907528dbea90c6d4464249f7d922c98f15243369fb9cae3981394"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb6e12b455925451b882bc8944ad4898b5b1a9a0a33168382bfb48f30dbf9fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea48b1635dae2303968b087319c89596f0df0cc6b37c5f1fea793d9b5156d50"
    sha256 cellar: :any,                 x86_64_linux:  "2c32dade2e9bd4e944deb8ecaf2946cbdca78fa1d276a131f787a8710f502cf4"
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
