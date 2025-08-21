class DatadogMcpServer < Formula
  desc "Community-maintained Datadog MCP server"
  homepage "https://github.com/winor30/mcp-server-datadog"
  url "https://registry.npmjs.org/@winor30/mcp-server-datadog/-/mcp-server-datadog-1.6.0.tgz"
  sha256 "e376bea68a2dc26ccf675a39f08f95c9c9fb0b4a44764c76e9762c53c9bbfcb9"
  license "Apache-2.0"

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
