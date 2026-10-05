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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5539190bd92bc78782b82cd31ab683c68d7d20f2428856875cf836f8b252155f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66a87ebc16f963bdbebb7c93129469917b3344724fabcb16a5d94c66169fa4db"
    sha256 cellar: :any,                 arm64_linux:   "9ade53870dfe5422241a70be85a08e3f1f7c318f55e9fa5a9db6650181b4a9ed"
    sha256 cellar: :any,                 x86_64_linux:  "c6bf1e97f738103f56cf94ffac47e8a5817ad650cf36a41a43b67daf32ba1c2e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
