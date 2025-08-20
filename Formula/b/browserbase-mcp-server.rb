class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.0.1.tgz"
  sha256 "0b720b596113f4640aa27d5e7339bcfb3da4ba21182c72179735267d44170c12"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "a24fbc19749d86aff209597accfb9288d0d535fc460f8d05723a9fbaf39ea499"
    sha256                               arm64_sonoma:  "ff865d10e2c891af21e79f163d4225032fe0bd8ff12f5dd81f7dd0d15f369542"
    sha256                               ventura:       "c11fe5c4283bf80f823b786097d8057e0be3e9e6b6b182e4d877326ab959c6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11a02799f9c6127edd8d5d0a3781a42ba4c4880c3e3febb26ac496c0bbcd224"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
    mv bin/"mcp-server-browserbase", bin/"browserbase-mcp-server"
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
