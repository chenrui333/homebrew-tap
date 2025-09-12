class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.1.1.tgz"
  sha256 "c1ea8ebd3cbe8e6eafbfd15d70a7d7a760c280d54475c8e50ac648a75f5f2200"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "f54d5edd90ca63f2c7193158e8a6120e21ba5e6053619cf93d721a35b2bd85d3"
    sha256                               arm64_sonoma:  "83880fb604daacf9c24a47b8a67e943907414f29ca06682cf7d02aed9c6c711b"
    sha256                               ventura:       "fa21a8c0f7b2d529aacfd23d780e3707620b3cb04b7aea755bda72f020e26750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15a79e329c44e320fb3520c308068f2b30076b2dc5681635d089773d0a68bcb2"
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
