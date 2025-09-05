class GrafanaMcpServer < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "59e99c9de5eacda34346535d1b24b80f635718b4229f87a90725d599c312b245"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d7e8dca31142d74fe3b16f99ffc916ea837a349527668200cd7389c4115029b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e748d8d30f03caa957b0d21ae0389490136cbe8c862a9c133de6878fa91f157"
    sha256 cellar: :any_skip_relocation, ventura:       "2fc7c4ec0bdd756ba355067b8239f34bd99a04b2f8d210b766cbdda402a140fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a06789492b4a0bd1f3e8119ef546c1a8bb909c032ece0ed5868b22a1289128b6"
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
