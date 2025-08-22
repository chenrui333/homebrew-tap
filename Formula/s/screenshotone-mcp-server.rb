class ScreenshotoneMcpServer < Formula
  desc "MCP server for Screenshotone"
  homepage "https://github.com/screenshotone/mcp"
  url "https://registry.npmjs.org/screenshotone-mcp/-/screenshotone-mcp-1.0.0.tgz"
  sha256 "31aa26fc5161fd369723d8c4962bbfc282fb52aa8bc06f602bbe5dfd8026999f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0700483c0136ec9f635f94cfdde7143530006efa69a6e71c47ef5de08c1c2096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ccc16faf9ed84adbede36c7cdb7ff9ccd415dd0f244160e994f281f3f1272a"
    sha256 cellar: :any_skip_relocation, ventura:       "bfd8a84648cb64aab697aba767d13d676efe5284dadf81ab8e5bc5a33f55b33e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f566a839bd8263c154426a0478b1c163ee9991788d2ec844311df40ba5f83f"
  end

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
