class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.15.6.tgz"
  sha256 "fb188fcf94c7edd72201f7323493ace693202ae2cd61265e9410e896096996dc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c1f7e749aa5384a1afd23c85a301249f1e9e26969b31b3c048a39065a4c07b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41458bc12facd8e241f26a7775517e0b2ffdb5b2f84fb16c335ceb408b81d94f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b83bce35b56583f30eeda8ef123677bb6212a19802c7d984ef628c0d71d4f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "556b07b6975de93c56899bbc936374b1b9539c17f05dc0aee592b067459685e5"
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
    assert_match "MCP server initialized with 41 tools (n8n API: configured)", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
