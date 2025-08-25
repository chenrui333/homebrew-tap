class GrafanaMcpServer < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "dd9b0ad8c408ea2ab44655e6233bc783aaad0560632659ae9586cc0af0cd4490"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6c96d4ac233f8d90945cc951980e6ee9660981be59f8c9b9097488c3690716d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc7334de3e39b6313066b41ef1de85401886539788909c6b380271f5082bb191"
    sha256 cellar: :any_skip_relocation, ventura:       "0f7b42ee135bb889a7e174de7bbd147b20192eeb208e06acef076f1a3a972360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11c5038ed1c5e53977ca8d7b919d51dbae736d4ed8bf9c01d458a686c61c4adf"
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
