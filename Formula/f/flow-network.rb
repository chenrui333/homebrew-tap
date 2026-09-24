class FlowNetwork < Formula
  desc "Real-time network throughput dashboard"
  homepage "https://github.com/programmersd21/flow"
  url "https://github.com/programmersd21/flow/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b6bcd7afdaa290253e33d9196fdb2349dc044c6bfe3b6e6500d0a3df7c0b13e4"
  license "MIT"
  head "https://github.com/programmersd21/flow.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2bae4f883108b087111e062527a4a7ae1e8ee0ad259cb5f8a0cd50ce2a0f912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b49f48629ef7977c0b00b8862486e185a5608ceb4a2470ac7e157d9cf7a9e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03fc4f53b8727a940389e6bddc4c045dc5c7e9b22b5a3b4cbb03000ecb73335d"
    sha256 cellar: :any,                 x86_64_linux:  "f245d1f80118b75f3dbafe4c9db09fbf9004324bc200b01cb8b1765cd6fc5b22"
  end

  depends_on "go" => :build

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
