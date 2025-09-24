class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.13.1.tgz"
  sha256 "4810f82be5e5db795a20e22d6e05bf61ce39e37634c8eac5a6905ee2c21f5974"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b43bdfbfabf91e5c68e7eb37d5908d2d2fd9f4aa8580bf5defd47d3b1cfa2047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda609b4290fe58b8b3038f12d4a72657322fda80ed81460d05bad004755d934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b378849674daf7d54e4f10351618cd3c72ed4e54e09e9e39eb510c0a3d6b90b"
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
