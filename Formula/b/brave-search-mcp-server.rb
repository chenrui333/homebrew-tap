class BraveSearchMcpServer < Formula
  desc "MCP server for Brave Search"
  homepage "https://github.com/brave/brave-search-mcp-server"
  url "https://registry.npmjs.org/@brave/brave-search-mcp-server/-/brave-search-mcp-server-2.0.9.tgz"
  sha256 "1a2800163d16d42bd4bab2f354ec9e2ccdb95669e6294c40c24439517013bf25"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecd1e9b56420762bf36c4104d8f3807eb637f4cac33b7baf02aa7ad3452813ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ffab44ad5c193d48f1eeb124adee0978edff3ccefa68113b211629ccc6fe08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74219cff7408dc7eba592180db7de688e21c3d8e9e3f02675c9718e5e0da6fda"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/brave-search-mcp-server --brave-api-key test --transport stdio 2>&1", json, 0)
    assert_match "Performs web searches using the Brave Search API", output
  end
end
