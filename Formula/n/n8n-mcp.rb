class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.13.2.tgz"
  sha256 "9daefac86e280a33c2b654a85bc810cab8db6a0f34e6a1e08c438949ea65a477"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f8b07b694f57e01088d11f9f84bcf8adcd775acc01b8473a725b9f6ee4c5a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0299370a5efd6242312b8cdb4022a1be2dcbaae4eaed601c4f4493e582cfddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22d3a72dceabba5f3a5dfb5fa1f3451cc196513146c27da30d83f229a182af5b"
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
