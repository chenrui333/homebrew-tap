class AppleHealthMcp < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.0.2.tgz"
  sha256 "7250b9b7a51bfc23f019b2b574efefbcbce8890ce4d70aea32a870e1269663ba"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "4bbf2b658446075045ce5ea0325d098fe05cfadf7c6e9114b9e5713ca21db914"
    sha256                               arm64_sequoia: "0e873eda8b1880c56c01d9fea0f20ad4cf223995dec4f7399147517f42363678"
    sha256                               arm64_sonoma:  "4a007a7bfbfa8e98d257a0cf09928e4f017c51a4c86a42b639614966f92aaa80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7de016c8d385b0117f3b392017e8e0e6c5351299a08f515444e4c213be2bd2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0978431759137ec64cc75b0c5bbbaf460d084df5ae40be19f35e5d764faf8a5"
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
