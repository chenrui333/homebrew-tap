class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.3.0.tgz"
  sha256 "50cbed5f096f035988701a73a01d16fdfffb68cb62d7bf7bb8713c1a82217128"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ba6c4fd298793a7f515b577975ee740e5a5bdbbd78964466e679da4b85115006"
    sha256 cellar: :any,                 arm64_sequoia: "59201e143f639289a3faad274cca4cc630f806678d0f221223e56c54c9f0a05c"
    sha256 cellar: :any,                 arm64_sonoma:  "59201e143f639289a3faad274cca4cc630f806678d0f221223e56c54c9f0a05c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0a6591a9698994fe01e976ad6ce5b48ccd48aa2d763349a74b18ed5323e30c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a78c6fa1f47b1033dc09eff3637a3f7169787ebac8e6e52346c3a6cdac14a859"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server-browserbase" => "browserbase-mcp-server"

    node_modules = libexec/"lib/node_modules/@browserbasehq/mcp-server-browserbase/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/browserbase-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"browserbase-mcp-server", json, 0)
    assert_match "Create or reuse a Browserbase browser session and set it as active", output
  end
end
