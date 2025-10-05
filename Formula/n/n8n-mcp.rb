class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.15.6.tgz"
  sha256 "fb188fcf94c7edd72201f7323493ace693202ae2cd61265e9410e896096996dc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc586b2bba271861ac53b502a25bbf7241b2d6763c4a584e09f50c4b81f4149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d2869cbad305dcf491c95349800f7dc7efbef61042da7daf01bb9e9a2f77e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95975d07e073eb1e7a4f7aeb478efd1d906a6ec4db4ea638bad87af1ca70196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b38f395fcf2b9b9eb9b692f9e6c466b2fcad2f289fc863031414678d0035e7"
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
