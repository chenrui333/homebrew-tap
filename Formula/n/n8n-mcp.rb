class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.14.5.tgz"
  sha256 "e5c67ff5e9e56e0b1ce1f43b10c987e9a21cbd149c44aff589dcc96bdb5db1fa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bc20609f936060f7dad95f75f68b18b52876cd0f46b739bc32a2e79d9ba77cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1609479d95f488957d4716e1c9bcd67b33f250673b22c8ef61d84936644cdb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1e2de943a00e6f14bbc85e6c2221c8c4f8d958c50a8a3d63830237ebe214e1"
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
