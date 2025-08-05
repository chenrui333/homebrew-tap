class AxiomMcpServer < Formula
  desc "MCP server for Axiom"
  homepage "https://github.com/axiomhq/mcp-server-axiom"
  url "https://github.com/axiomhq/mcp-server-axiom/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "73920c83e7da63e4747dce3ac867a32458db9079fed56a0b6f3ef7e882b5134c"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["AXIOM_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/axiom-mcp-server 2>&1", json, 1)
    assert_match "create tools: failed to create Axiom client: invalid token", output
  end
end
