class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.4.1.tgz"
  sha256 "baf910db6503525f8ec43fb4f6ee7684f3221b231d319e8a5801e6b137fd6f90"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "7f38612e21bf815e3ff2f9bbf1bdbd0a2a3866f5cb03c97850e59d583cb00125"
    sha256 cellar: :any,                 arm64_sequoia: "305b90f2755672f352ef22653837230e2a1005d9f9611ae8456bdd731209caf9"
    sha256 cellar: :any,                 arm64_sonoma:  "305b90f2755672f352ef22653837230e2a1005d9f9611ae8456bdd731209caf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0248a1b65c465cf4be0c084fbe0c3cd51b356b2680cafbbf4ade3388a316f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a14d5d6afd6ff3a414da916abfba2cfe04692ce8cc0c0aba5a6551fd60e585b"
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
