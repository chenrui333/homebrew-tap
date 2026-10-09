class FlowNetwork < Formula
  desc "Real-time network throughput dashboard"
  homepage "https://github.com/programmersd21/flow"
  url "https://github.com/programmersd21/flow/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "3fdb7a2ca6bcb294ec18d955fe8e9612135b89b921811628e2e3165980bdf1d7"
  license "MIT"
  head "https://github.com/programmersd21/flow.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9694e2c448bc4249ab9a946cae429c4eb08382ab79e999f29fa1d4a4a9092cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7803249a511201e5643777ab4b169aa4bc8ea161347700bd68471807bbd3cc81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c25a18aa9f8356ec7ec01cb858b2ce5d95d06d24e6342c6a343d41ad2210ffe"
    sha256 cellar: :any,                 x86_64_linux:  "07be7eb3cc9ae85c1a20a34fda0b5fc2f28d1f025c40cbdc8b96de2eb02581e2"
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
