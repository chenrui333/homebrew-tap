class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.14.5.tgz"
  sha256 "e5c67ff5e9e56e0b1ce1f43b10c987e9a21cbd149c44aff589dcc96bdb5db1fa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e3e6eedfd6c08ea0cacba161d4919a3ab2c2fea11b8206303852b66328886de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6920a1b03a533123c292f627ae4b75d11ce3ecbfeaa0dfb575a03481704f18a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1df4d3363d8ca38e88db51ad6d297f02a5165c08b150482f177d07006d2785bf"
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
