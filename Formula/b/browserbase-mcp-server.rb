class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.4.3.tgz"
  sha256 "d0255d41e987f916797eda5c209de4b219090f83e0dd01a713b6bd398d81ad81"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "78586c3a4677ba8bc5ee3ef35534cfc57255d621df068a9f745caeacbc88c2b1"
    sha256 cellar: :any,                 arm64_sequoia: "a4934d56493eb2403f0240d3f86cc1fcbaca3e1b3de13e96c54ccb5826efafa4"
    sha256 cellar: :any,                 arm64_sonoma:  "a4934d56493eb2403f0240d3f86cc1fcbaca3e1b3de13e96c54ccb5826efafa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8c4a6dff3b51c2cd3003b7ea0eee685b4c524f5d4bfb3184e60f7815dfd28d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee6790d31d712ca268b76d1ec88234f51865ed1a4906b4a7342494ed495eb399"
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
