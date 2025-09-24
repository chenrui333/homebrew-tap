class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.13.0.tgz"
  sha256 "947415f50f1049b4669d4d99dac2846a0237bfc1777062a9c8a39dd04e93c573"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445952df974428f4bec7ba298735dd178cebe6dc9c25c7973ff2592ac8363622"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7378f3b0c98f540580fa17e8b95cb93d0a9a2aec55c09e14a0f77e58c1881cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c653325eb7b8eb201ede68c1cb8477613bec2d04ad7a9034a244fabe28298ea"
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
