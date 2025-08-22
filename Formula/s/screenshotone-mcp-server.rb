class ScreenshotoneMcpServer < Formula
  desc "MCP server for Screenshotone"
  homepage "https://github.com/screenshotone/mcp"
  url "https://registry.npmjs.org/screenshotone-mcp/-/screenshotone-mcp-1.0.0.tgz"
  sha256 "31aa26fc5161fd369723d8c4962bbfc282fb52aa8bc06f602bbe5dfd8026999f"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
