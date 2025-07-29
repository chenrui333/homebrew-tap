class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.3.0.tar.gz"
  sha256 "7f0bb64d2713ab90b382f52e845f1b5406db9fa5657dbc3e21a19e1634ae77b8"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Gitea MCP Server", pipe_output(bin/"gitea-mcp-server stdio", json, 0)
  end
end
