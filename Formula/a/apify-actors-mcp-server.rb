class ApifyActorsMcpServer < Formula
  desc "MCP server for Apify"
  homepage "https://docs.apify.com/platform/integrations/mcp"
  url "https://registry.npmjs.org/@apify/actors-mcp-server/-/actors-mcp-server-0.4.10.tgz"
  sha256 "f40c0c3779d0fde30614d21c8c1d98360a017de800c7367187524a84a9d713f7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee01be2315582e1cc4d177da42169228a27360f1b4f15abeaa02cee894f718cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ffa7d6d8aab8a61ffb65913c42d9bfecda85ea72a8c299712a596fa70ea868f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f79febbba9d6f09c92179aaec53c2b2f72e4c21aab723a7a2f80aaf9261e053"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["APIFY_TOKEN"] = "test_token"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/actors-mcp-server 2>&1", json, 1)
    assert_match "User was not found or authentication token is not valid", output
  end
end
