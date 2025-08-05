class ScreenshotoneMcp < Formula
  desc "MCP server for Screenshotone"
  homepage "https://github.com/screenshotone/mcp"
  url "https://registry.npmjs.org/screenshotone-mcp/-/screenshotone-mcp-1.0.0.tgz"
  sha256 "31aa26fc5161fd369723d8c4962bbfc282fb52aa8bc06f602bbe5dfd8026999f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72324b2bcac75f496570d2185538fe9c46762d9e026ed952bbf81b96f7ffbc29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e93fc6527f5e00834d15b635da1b2e6c1442aab74b0249ebedd46138ff488efe"
    sha256 cellar: :any_skip_relocation, ventura:       "8f729ceb7148d116fdd058d74f1c055486a896764cdb938f5863a4038266467e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f229bfaea1e863d20794aa6f09d0daa5c8a50fca522604afa10b2a5545638f7f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
    mv bin/"screenshot", bin/"screenshotone-mcp"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"screenshotone-mcp", json, 0)
    assert_match "Render a screenshot of a website and returns it as an image", output
  end
end
