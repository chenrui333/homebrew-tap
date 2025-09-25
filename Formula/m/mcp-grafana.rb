class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b3f909d701f83f751c26f73f84135cab0749c04093c69d25adf3f902d9f95ba1"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb82098bbe62e55ac077fefdc5531022b59872e61139dc334fa59ebdb82cf0de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf90033d8d05bf594f7d8299b0618ae28219f5d9d2fcd1ff90f2d00d6424d335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6e5e84195a3b205c9786031ea28a672a8c6472d72cfdab3b2341d75e766916"
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
