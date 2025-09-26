class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.14.1.tgz"
  sha256 "ca2d0f2e058ac61657b97902cce1826dd24ec6ac066b74ae929ea3aaf9fe6505"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97d617b69c293a3153f41357e8e805f2c39ffccece22b0aee41c67a500fd8b4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920b9eb912ec134bc17ab9a146423f682dde774bda7a462e72affa54d8874f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7fae3db8ac5ca3560fdcf3f7d2e10e0a0e576666b54d24030ca6b2f51c75218"
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
