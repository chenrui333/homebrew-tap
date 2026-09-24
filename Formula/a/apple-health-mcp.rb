class AppleHealthMcp < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.4.5.tgz"
  sha256 "f4252273cf9e03735cc03aac0eac95de0a81951aa1b43772ed77c6a815d92ec9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7f20aafd2e52a36e132ce2c0f1c50f5a0d7461b1d425ac82de30d294e37a98a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da6ee38e88933e5515ffcac911682ebb8c67142fa509e9d9979b386be8e94b1"
    sha256 cellar: :any,                 arm64_linux:   "098bd7ee7ea4c8047599898e04b6d5e6757c4acf3652ff98d77906066b2616f0"
    sha256 cellar: :any,                 x86_64_linux:  "45efea46f7e88822abf758af4ef3439dc779a85b2bd41d74f98080936cf5474e"
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
