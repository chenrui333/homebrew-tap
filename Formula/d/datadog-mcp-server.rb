class DatadogMcpServer < Formula
  desc "Community-maintained Datadog MCP server"
  homepage "https://github.com/winor30/mcp-server-datadog"
  url "https://registry.npmjs.org/@winor30/mcp-server-datadog/-/mcp-server-datadog-1.6.0.tgz"
  sha256 "e376bea68a2dc26ccf675a39f08f95c9c9fb0b4a44764c76e9762c53c9bbfcb9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44140b73a5c4f046ae4a8d89028c96997cabc3f8195c7ad919b7488ffb7f5b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4f3ed19548dc9e51119fb47681913f9050cd2bd0f1ab1a4b7d9d7f9fca8c36e"
    sha256 cellar: :any_skip_relocation, ventura:       "851624de7eabbcaf60a9161e9bd2d4c5326902647a741f165340620f942c73a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a1b735edd54ef54720e7835aa49b9b464f517d3a09b05613c0829c16278b676"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server-datadog" => "datadog-mcp-server"
  end

  test do
    ENV["DATADOG_API_KEY"] = "test_api_key"
    ENV["DATADOG_APP_KEY"] = "test_app_key"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"datadog-mcp-server", json, 0)
    assert_match "Query timeseries points of metrics from Datadog", output
  end
end
