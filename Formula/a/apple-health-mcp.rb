class AppleHealthMcp < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.4.1.tgz"
  sha256 "1eb0cc00105954b74f4106b978668482582d571a640279137075736449c75f93"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "92d0d830954da2c174d311ceca0813642bc2917e48a53506a606f210b78ca672"
    sha256               arm64_sequoia: "024a8d8fcfd938cb940573d2fb671e07088d0a0855266f8190d937390fd0db8a"
    sha256               arm64_sonoma:  "d4b7ec963eb07f45ea4aef97f1b48dcc845d7446e8838c10fae551fb0190e9b0"
    sha256 cellar: :any, arm64_linux:   "8fad8f08bcf6046a1ca241fed338f0a1216887b0cdab143372727fc22818150d"
    sha256 cellar: :any, x86_64_linux:  "8608ef171722050a88800ca84720cdaa697fe3f1a5c35f7a714abc4f64f34932"
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
