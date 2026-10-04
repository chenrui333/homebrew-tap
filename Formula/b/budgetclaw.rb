class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.79.tar.gz"
  sha256 "b5ce7553a89262d979effc7db9d03b69c2e7f17bcace68bca7551824a47fde5d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3afc27a164e8b720300ad7cd8d85275003ee39fc9a2b6e82cecd770fa62d9a2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a8ad5893dbeab31b024de4d55acf8a35d3b1e95b512a9e4e93e75dc7eeacf4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee76a5a4d846cc74f9d79d7a0fe68d45861feeaf3d46613c003df73f9f1a459"
    sha256 cellar: :any,                 x86_64_linux:  "dfc4d24da0545f984ea7f227d9dbe79345814a1aaa6f236293d45cffaa7349c3"
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
