class DatadogMcpServer < Formula
  desc "Community-maintained Datadog MCP server"
  homepage "https://github.com/winor30/mcp-server-datadog"
  url "https://registry.npmjs.org/@winor30/mcp-server-datadog/-/mcp-server-datadog-1.7.0.tgz"
  sha256 "5036898f75a9e4d5609670fce7894372d651350277b1c4891c61c5cfb14db012"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ffc2df9e69d9dc0b64660693bfede66d77e5a828b80b4baab66b06fa809e96d3"
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
