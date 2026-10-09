class FlowNetwork < Formula
  desc "Real-time network throughput dashboard"
  homepage "https://github.com/programmersd21/flow"
  url "https://github.com/programmersd21/flow/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "3fdb7a2ca6bcb294ec18d955fe8e9612135b89b921811628e2e3165980bdf1d7"
  license "MIT"
  head "https://github.com/programmersd21/flow.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "415df2936da2139a6503f67cb3468794bc03a3e3fa227f3629b7e1b84d828e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "994abd91d2bfb5aabe2a65ae659a669a8926133b5f1beac1799ff2c22287c525"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2430f8886e340978e1a7fa60e60c26fe71ba8d93c883a310d8a4cd9e77e783b2"
    sha256 cellar: :any,                 x86_64_linux:  "6ca886221fc4afab78496a585c2268992e985757d0331a0f36deeb60c7c5bd57"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/flow"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow-network --version")
    output = JSON.parse(shell_output("#{bin}/flow-network --json --refresh 10ms"))
    assert_equal "ok", output.fetch("status")
    assert_operator output.fetch("download_bps"), :>=, 0
  end
end
