class ScreenshotoneMcpServer < Formula
  desc "MCP server for Screenshotone"
  homepage "https://github.com/screenshotone/mcp"
  url "https://registry.npmjs.org/screenshotone-mcp/-/screenshotone-mcp-1.0.0.tgz"
  sha256 "31aa26fc5161fd369723d8c4962bbfc282fb52aa8bc06f602bbe5dfd8026999f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e4b3a0fdf6ca3515b6dfe65fd29d12a49d86fe1cbd8b94245b7ae093f3e321c3"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/screenshot" => "screenshotone-mcp-server"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"screenshotone-mcp-server", json, 0)
    assert_match "Render a screenshot of a website and returns it as an image", output
  end
end
