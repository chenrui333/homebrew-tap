class DatadogMcpServer < Formula
  desc "Community-maintained Datadog MCP server"
  homepage "https://github.com/winor30/mcp-server-datadog"
  url "https://registry.npmjs.org/@winor30/mcp-server-datadog/-/mcp-server-datadog-1.8.0.tgz"
  sha256 "c2736164cbd50e17b846fb416da0dd4fdcba4d76ff629c138a9f5e3b848b7954"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "9d2e07ecd87ad8c1fb5ad152aa770393132fe11de44b299829d19ef4f3d602a7"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "pkg", "delete", "devDependencies"
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "pkg", "delete", "devDependencies"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server-datadog" => "datadog-mcp-server"
  end

  test do
    ENV["DATADOG_API_KEY"] = "test_api_key"
    ENV["DATADOG_APP_KEY"] = "test_app_key"

    requests = [
      { jsonrpc: "2.0", id: 1, method: "initialize",
        params: { protocolVersion: "2025-03-26", capabilities: {},
                  clientInfo: { name: "homebrew", version: "1.0" } } },
      { jsonrpc: "2.0", id: 2, method: "tools/list" },
    ]
    json = requests.map { |request| JSON.generate(request) }.join("\n") + "\n"

    output = pipe_output(bin/"datadog-mcp-server", json, 0)
    responses = output.lines.map { |line| JSON.parse(line) }
    initialization = responses.find { |response| response["id"] == 1 }
    assert_equal version.to_s, initialization.dig("result", "serverInfo", "version")
    assert_match "Query timeseries points of metrics from Datadog", output
  end
end
