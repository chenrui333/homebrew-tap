class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.7.0.tgz"
  sha256 "f5a99edf633089474e3ca1dbd928c560eac63f1e8a5ff2d6f048b92d0cd4da8c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "09dc9b571dbbd98e2cf8a03b586f94dc50b1b3dc7a2ad728125d1d2cf5f59dfb"
    sha256 cellar: :any,                 arm64_sequoia: "09dc9b571dbbd98e2cf8a03b586f94dc50b1b3dc7a2ad728125d1d2cf5f59dfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d264a14af6896ee3f292da7a9376b15e383ea0fe869ce4004eed4ef2512e7b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731e478367c9b2734207e24aaa906dbe66c8b93d7376e440864511238a740fd5"
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
