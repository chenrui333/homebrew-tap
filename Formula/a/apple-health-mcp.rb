class AppleHealthMcp < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.3.0.tgz"
  sha256 "930bbfd19fdd99930693bf4705ab9b405bc2caa39eab1f64edcae1c9772648db"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "92d0d830954da2c174d311ceca0813642bc2917e48a53506a606f210b78ca672"
    sha256               arm64_sequoia: "024a8d8fcfd938cb940573d2fb671e07088d0a0855266f8190d937390fd0db8a"
    sha256               arm64_sonoma:  "d4b7ec963eb07f45ea4aef97f1b48dcc845d7446e8838c10fae551fb0190e9b0"
    sha256 cellar: :any, arm64_linux:   "8fad8f08bcf6046a1ca241fed338f0a1216887b0cdab143372727fc22818150d"
    sha256 cellar: :any, x86_64_linux:  "8608ef171722050a88800ca84720cdaa697fe3f1a5c35f7a714abc4f64f34932"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    ENV["npm_config_build_from_source"] = "true"
    system "npm", "rebuild", "duckdb", "--prefix", libexec/"lib/node_modules/@neiltron/apple-health-mcp"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    ENV["NODE_NO_WARNINGS"] = "1"
    output = pipe_output("#{bin}/apple-health-mcp 2>&1", json, 1)
    assert_empty output
  end
end
