class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.94.tar.gz"
  sha256 "6c1bf872f2a4bd7e78a29b823917c484b726ca8f838b031f092773db9e7c8382"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0890fccfb27476e31be34a74282de4734e1aa3ac061e632c251056b97224693e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5246ca022c00a6477e7029f915b888afd2e7a14ae9f32d7943fa355f321063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1470fa4abf9d583cb3cd43e8c556b649dba8257527063147eca47f6f148ecfdc"
    sha256 cellar: :any,                 x86_64_linux:  "19c03e7de2c5fc9fac553da1456e4c5f7447e3d5f02e2c62f9a47801c787b495"
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
