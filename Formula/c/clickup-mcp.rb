class ClickupMcp < Formula
  desc "MCP Server for ClickUp"
  homepage "https://github.com/hauptsacheNet/clickup-mcp"
  url "https://registry.npmjs.org/@hauptsache.net/clickup-mcp/-/clickup-mcp-1.6.0.tgz"
  sha256 "be6eef6ec32fd71a32c63d6f9cf99e7db3c8d833ebe23803838960909551d1e7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ec16dc9066e6cfe983720347834bbcc101a7ede2ae51f899aebdd4937239dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5725bc09c698f95938037a895d924652c074f9645238b188f829e6e1eaba941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efce4fdc6fb1d2a0dba77e70d25556f132af844fce467d5ec3ef67270eec1b48"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["CLICKUP_API_KEY"] = "your_api_key"
    ENV["CLICKUP_TEAM_ID"] = "your_team_id"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/clickup-mcp 2>&1", json, 0)
    assert_match "Error fetching user info: 401 Unauthorized", output
  end
end
