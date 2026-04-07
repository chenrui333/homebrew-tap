class McpServerAirbnb < Formula
  desc "Search Airbnb using your AI Agent"
  homepage "https://www.openbnb.org/"
  url "https://registry.npmjs.org/@openbnb/mcp-server-airbnb/-/mcp-server-airbnb-0.1.4.tgz"
  sha256 "2d1cbfb4ac0c15b942fdcd10e2daa392268eb4f018da936557490de32b878378"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "02042cc629412ca395d1292cfd704acc54201aba0a9515499b1e966e874b4d94"
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
