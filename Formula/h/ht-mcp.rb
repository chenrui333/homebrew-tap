class HtMcp < Formula
  desc "Pure Rust implementation of MCP server for headless terminal"
  homepage "https://github.com/memextech/ht-mcp"
  url "https://github.com/memextech/ht-mcp.git",
      tag:      "v0.1.3",
      revision: "df9e4192db026850bc13661ffada1b4c65a3e4fa"
  license "Apache-2.0"
  head "https://github.com/memextech/ht-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904c952135f3b8e75dc0b00b186614e33a7f348a378a06b8514a840044e6713f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b1b8cc898c5b4b77c46efdd3ba2b2d5b1ea28e910c9919facae5f0f7c51cb2"
    sha256 cellar: :any_skip_relocation, ventura:       "dd1309b76b617563ee419abcb7befe59f1c0df33fd6ab9656a6a75806e042b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc7304b2a994662dbc16e65b0fd99ccb2bbe634f43e8c14c5bb653f87f5c30c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new HT session", pipe_output(bin/"ht-mcp", json, 0)
  end
end
