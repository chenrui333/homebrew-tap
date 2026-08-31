class AppleHealthMcp < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.4.1.tgz"
  sha256 "1eb0cc00105954b74f4106b978668482582d571a640279137075736449c75f93"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1aa398473b3ee611e6ab7ed6fb619b8640109762acc6e0b789d4740a102b54b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a4733e8a8bc5176e3f889d2c2a7c34efe56f85ddbc215bedbb90dbf70dba64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8517cd6f7300fec15656f7252aa976ec5888136bec053bd59b08c599f6204842"
    sha256 cellar: :any,                 arm64_linux:   "ac8c068238acd90f2a0e52226d02a4924da4087a345845325f2e0246cf84f1b0"
    sha256 cellar: :any,                 x86_64_linux:  "458002c0c18a6976226a08a0823abff8d5aadb10d8dd48deb69aa8205512e04f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    ENV["npm_config_build_from_source"] = "true"
    system "npm", "rebuild", "duckdb", "--prefix", libexec/"lib/node_modules/@neiltron/apple-health-mcp"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "json"
    require "open3"
    require "timeout"

    messages = [
      { jsonrpc: "2.0", id: 1, method: "initialize", params: {
        protocolVersion: "2025-03-26", capabilities: {}, clientInfo: { name: "brew-test", version: "1" }
      } },
      { jsonrpc: "2.0", method: "notifications/initialized" },
      { jsonrpc: "2.0", id: 2, method: "tools/list" },
    ]
    env = { "HEALTH_DATA_DIR" => testpath.to_s, "NODE_NO_WARNINGS" => "1" }
    Open3.popen3(env, bin/"apple-health-mcp") do |stdin, stdout, _stderr, wait_thread|
      begin
        messages.each { |message| stdin.puts(JSON.generate(message)) }
        stdin.close
        responses = Timeout.timeout(30) { Array.new(2) { JSON.parse(stdout.gets) } }
      ensure
        Process.kill("INT", wait_thread.pid) if wait_thread.alive?
      end
      assert_predicate wait_thread.value, :success?
      assert_equal "apple-health-mcp", responses.dig(0, "result", "serverInfo", "name")
      assert_includes responses.dig(1, "result", "tools").map { |tool| tool["name"] }, "health_schema"
    end
  end
end
