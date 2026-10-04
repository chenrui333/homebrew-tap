class ShadcnUiMcpServer < Formula
  desc "MCP server for Shadcn UI v4"
  homepage "https://github.com/jpisnice/shadcn-ui-mcp-server"
  url "https://registry.npmjs.org/@jpisnice/shadcn-ui-mcp-server/-/shadcn-ui-mcp-server-3.0.0.tgz"
  sha256 "cffd5602aff8d49a26dbf711add9c46e7f89c2cd821541afcae113c73dadbf86"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3fc396ed670e3be98f7f1629ba54d0300ebdaf77e198cd0b1e4baa106d081db5"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "open3"
    require "timeout"

    assert_match version.to_s, shell_output("#{bin}/shadcn-mcp --version")

    Open3.popen3(bin/"shadcn-mcp", "--mode", "stdio") do |stdin, stdout, stderr, wait_thr|
      errors = Thread.new { stderr.read }
      response_for = lambda do |id|
        loop do
          response = JSON.parse(stdout.readline)
          break response if response["id"] == id
        end
      end

      begin
        Timeout.timeout(30) do
          stdin.puts JSON.generate(jsonrpc: "2.0", id: 1, method: "initialize",
                                   params: { protocolVersion: "2025-03-26", capabilities: {},
                                             clientInfo: { name: "homebrew", version: "1.0.0" } })
          response = response_for.call(1)
          assert_equal version.to_s, response.dig("result", "serverInfo", "version")
          stdin.puts JSON.generate(jsonrpc: "2.0", method: "notifications/initialized")
          stdin.puts JSON.generate(jsonrpc: "2.0", id: 2, method: "tools/list")
          response = response_for.call(2)
          assert_match "Get the source code for a specific shadcn/ui v4 component", JSON.generate(response)
        end
      ensure
        stdin.close
        Process.kill("TERM", wait_thr.pid) if wait_thr.alive?
        wait_thr.value
      end
      assert_match "No GitHub API key provided. Rate limited to 60 requests/hour", errors.value
    end
  end
end
