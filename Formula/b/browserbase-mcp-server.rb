class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.1.2.tgz"
  sha256 "cc7b64c781947425865b81d70a03e2a9d826c6c0dd4740de5b241ad0b7a40357"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "987a64aaae3f128f4bf4fbb06d70273c740d933e844888772762df9136ca3b4c"
    sha256 cellar: :any,                 arm64_sonoma:  "65890fd9a93ad6f8806f9c97d56dd0d6235edaa2276ebf1ead3724b4ef47887a"
    sha256 cellar: :any,                 ventura:       "2a2f57ddb06d6a898598ac412d8c1ee3cbdecb52b8c25ae2b32068e91fbbceb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa1bddb0e41362c6c669ab4ce9cde668c915081709b8a82c5c40895699cee6f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server-browserbase" => "browserbase-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/browserbase-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"browserbase-mcp-server", json, 0)
    assert_match "Create parallel browser session for multi-session workflows", output
  end
end
