class McpServerAirbnb < Formula
  desc "Search Airbnb using your AI Agent"
  homepage "https://www.openbnb.org/"
  url "https://registry.npmjs.org/@openbnb/mcp-server-airbnb/-/mcp-server-airbnb-0.3.0.tgz"
  sha256 "d1dbc2e10b72292d1eaad4bc1a6e8ef4119392eba9fc0df02f60e2ebc5f3a2f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "fb33f4e9f5e769b7bee2501ef9e2a95a28988788816114e2c875b98f116d794f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/mcp-server-airbnb 2>&1", json, 0)
    assert_match version.to_s, output
    assert_match "Location to search for (city, state, etc.)", output
  end
end
