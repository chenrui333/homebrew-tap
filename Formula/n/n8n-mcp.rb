class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.12.2.tgz"
  sha256 "c6796d047792883416dd9bb4a8543501dcf3f5324c5b4d6c82d0fcec82b9de84"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc3e637db93bd0b8f0df134a9895e3fdfae3c0d046bc5837abb295fd5563cc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "789736249bf726ae34bf55b22b09d251a70abe512c345b69033f0b0c2dd89b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ec739e93b06fc59354d182d6f263a457b3225110351d91e40069d7b61680e8"
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
