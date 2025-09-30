class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.14.4.tgz"
  sha256 "3c352de34a982b9d2caf543d800bfdc938e4b65dc575ae0747bdad2f2233b7bc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03daac727dbe7b504bc7ae47e70c4003e8de7372cba2c1dadb680711c57a5cf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b51557e7cb666e8c3588c27c9410b7746c0b1c7e5e3d453b079d77d67c57f066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7086c9ef0d8b9a553dc74817c56fc5d8173934a882cfb34a5c05180ccf932c96"
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
