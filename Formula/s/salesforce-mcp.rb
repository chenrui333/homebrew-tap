class SalesforceMcp < Formula
  desc "MCP Server for interacting with Salesforce instances"
  homepage "https://github.com/salesforcecli/mcp"
  url "https://registry.npmjs.org/@salesforce/mcp/-/mcp-0.21.2.tgz"
  sha256 "24a8296a1837a20c3b13dd610a048ceeeb25d57e9e6fe215f5d8dd9d48494cdc"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b2c78179c8fbf7e64f3b4b32f5e4fa82b043e3f853d6345bbe403df1d127aff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e16498807c8e9a849db5f1b71ce280f936a01949b4a884bddf0e0df89c6c67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8790c5f891c1a53674b1a27e09e3f27afae22e29040aa86d68bb6d6c12c7455"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sf-mcp-server --version 2>&1")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/sf-mcp-server --orgs DEFAULT_TARGET_ORG --toolsets all 2>&1", json, 0)
    assert_match "The username or alias for the Salesforce org to run this tool against", output
  end
end
