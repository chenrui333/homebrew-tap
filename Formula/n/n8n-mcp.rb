class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.14.6.tgz"
  sha256 "40999c3b0e4de895da34765be60f201c69b61e60b4c15fea28140cf5436f7f04"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58a509c2c259a5ce27e72dbb0586a7f468657e31f526c4c5a3a952a72f3a12f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ae6ff042ec8d480b26417efff81adfdd4352825b02c7d15ecfff0f90abb3a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25128e69035f127bfc245f4c9f903671272838f708ec730848ef7c72b2fbbae9"
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
