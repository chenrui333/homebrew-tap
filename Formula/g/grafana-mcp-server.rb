class GrafanaMcpServer < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "fd28379675f31e1f16439837cc99c70f6f2f009827d4b812d7aa5b0d18ec740e"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80934634635980968c84239d5bfdd952660634ecbf87a1114123c2ba2fde684a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfcdfcc89207f5d0f801505e78eb3eaf93a2c9e9ae4c7695a9529dd000b174ed"
    sha256 cellar: :any_skip_relocation, ventura:       "cabeb11ee54939dab2c64a434683c24559a14f196fcad81bc0a64c81afda50bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45b057959c79456548815d59045cd61ef7eb0a112e34643071f7a967f20d95b8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"grafana-mcp-server"), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"grafana-mcp-server", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end
