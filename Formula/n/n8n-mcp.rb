class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.15.3.tgz"
  sha256 "c3dcf2b900fe56958ccd99110f499f0dc2759bba4b7cbc69d64ff26678191437"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ba84e65ee895267a699c8bac5a8333d71a5bc902b86f338296be9e8f3e1e1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e4473c8231f29a98f2b3fb2fd5d4bf641223c88794dd5717597b6618f436748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e77b6c2e72727192c7f1dbb88ca133cd6de07278f974d70fae40a8bb2a9f7e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["N8N_API_URL"] = "https://your-n8n-instance.com"
    ENV["N8N_API_KEY"] = "your-api-key"

    output_log = testpath/"output.log"
    pid = spawn bin/"n8n-mcp", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "MCP server initialized with 42 tools (n8n API: configured)", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
