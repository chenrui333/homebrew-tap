class SlackMcpServer < Formula
  desc "Powerful MCP Slack Server with multiple transports and smart history fetch logic"
  homepage "https://github.com/korotovsky/slack-mcp-server"
  url "https://github.com/korotovsky/slack-mcp-server/archive/refs/tags/v1.1.24.tar.gz"
  sha256 "35be4864d87578cf6dd730b953f65fe35b057d8a90b8dd0ab42d294cc7b38db3"
  license "MIT"
  head "https://github.com/korotovsky/slack-mcp-server.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91247ff79bb02f573aa2414b8304197fa96b95b1cbcb101789f25dabc5021cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c199a813874bc4e00bb9fb98fd71173786c6aeb3a16e2d9c8ab1e7578958add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0666437f7838e2d7c9597422c9110db6789b9998a7119926a715abf3b6db1813"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/slack-mcp-server"
  end

  test do
    # User OAuth token
    ENV["SLACK_MCP_XOXP_TOKEN"] = "xoxp-test-token"
    assert_match "Failed to create MCP Slack client", shell_output("#{bin}/slack-mcp-server 2>&1", 1)
  end
end
