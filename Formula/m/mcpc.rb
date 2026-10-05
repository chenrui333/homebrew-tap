class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.7.0.tgz"
  sha256 "f5a99edf633089474e3ca1dbd928c560eac63f1e8a5ff2d6f048b92d0cd4da8c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ed38ec3ded717581875db1310accaba27da0973a47ca5f4837c11d4747af4a2d"
    sha256 cellar: :any,                 arm64_sequoia: "ed38ec3ded717581875db1310accaba27da0973a47ca5f4837c11d4747af4a2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d677665b88019221f847bb85066012130073d707d3a8c4c633b9cd9fa8a21b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0231c5051ddf40c27a9a1fc16e2fc39b7d7914e0afde15851ea245b1327decde"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  # mcpc sessions run through a bridge process that listens on a local Unix socket.
  allow_network_access! :test

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch", ignore_scripts: false)
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpc --version")

    # Minimal local stdio MCP server so the session never leaves the machine.
    (testpath/"server.js").write <<~JS
      const rl = require("readline").createInterface({ input: process.stdin });
      const send = (m) => process.stdout.write(JSON.stringify(m) + "\\n");
      rl.on("line", (line) => {
        const msg = JSON.parse(line);
        if (msg.id === undefined) return;
        if (msg.method === "initialize") {
          send({ jsonrpc: "2.0", id: msg.id, result: { protocolVersion: msg.params.protocolVersion,
            capabilities: { tools: {} }, serverInfo: { name: "brew-demo", version: "1.0.0" } } });
        } else if (msg.method === "tools/list") {
          send({ jsonrpc: "2.0", id: msg.id, result: { tools: [{ name: "brew_echo",
            description: "Echo test", inputSchema: { type: "object" } }] } });
        } else {
          send({ jsonrpc: "2.0", id: msg.id, result: {} });
        }
      });
    JS
    (testpath/"mcp.json").write <<~JSON
      {"mcpServers":{"demo":{"command":"#{formula_opt_bin("node")}/node","args":["#{testpath}/server.js"]}}}
    JSON

    connect_output = shell_output("#{bin}/mcpc connect #{testpath}/mcp.json:demo @test 2>&1")
    assert_match "Session @test created", connect_output

    assert_match "brew_echo", shell_output("#{bin}/mcpc @test tools-list 2>&1")
  ensure
    system bin/"mcpc", "close", "@test"
  end
end
