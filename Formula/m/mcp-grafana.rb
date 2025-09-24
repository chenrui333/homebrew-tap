class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "59e99c9de5eacda34346535d1b24b80f635718b4229f87a90725d599c312b245"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "524fb4b8308eba9afafc18e8466dadffaac380ab4aaa9902571fcde6231217ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aef1716be645e2701bdfe4a697216fc15d3a67c1339a73534c6b63c164a8447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6b26d30ff5240896d79e23390259cb2869e4581aa5cd81e9d06e38d78716bfe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"mcp-grafana", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end
