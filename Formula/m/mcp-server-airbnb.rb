class McpServerAirbnb < Formula
  desc "Search Airbnb using your AI Agent"
  homepage "https://www.openbnb.org/"
  url "https://registry.npmjs.org/@openbnb/mcp-server-airbnb/-/mcp-server-airbnb-0.3.0.tgz"
  sha256 "d1dbc2e10b72292d1eaad4bc1a6e8ef4119392eba9fc0df02f60e2ebc5f3a2f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f12580678ee217dbbb8b7208edcbacb3cae0721518e7e00d402dac2809b10493"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    # Skip the startup robots.txt fetch from airbnb.com.
    output = pipe_output("#{bin}/mcp-server-airbnb --ignore-robots-txt 2>&1", json, 0)
    assert_match version.to_s, output
    assert_match "Location to search for (city, state, etc.)", output
  end
end
