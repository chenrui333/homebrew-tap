class AppleHealthMcp < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.2.1.tgz"
  sha256 "dd6cb779cd02c474fca83876ffb30d62293028ed7036aac77195a7bac443215f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "2dab2a345776e4f9dbf6640ed4f93dc939a9cf36afcbb5a490f31c017eed7d4d"
    sha256               arm64_sequoia: "e5f264db74ddf50fe1982d8961e5ce209655ae71e28eedcfddcc0162a1ce73f7"
    sha256               arm64_sonoma:  "41e46a72423e581f7d297d76f5b27ab12b0b1e2d1631c7598686fdadf5d7dfd9"
    sha256 cellar: :any, arm64_linux:   "bc51210e798b6638f914c35d47a9a8ac0d02a0d37b4607afc452edc4e86e32d2"
    sha256 cellar: :any, x86_64_linux:  "592207353dc1f97f422186705f48dfe244bffdbe4962b9c98fb43e886a9bcbf7"
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
