class SalesforceMcp < Formula
  desc "MCP Server for interacting with Salesforce instances"
  homepage "https://github.com/salesforcecli/mcp"
  url "https://registry.npmjs.org/@salesforce/mcp/-/mcp-0.21.4.tgz"
  sha256 "d88184d8b1f359742b094e864b472f30819425a9a65c2624418fc6486c3ea2ec"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "129dc8bdb6346a432b909acb2c9a29d98142930afb75ab9dde32e4dc814c0e95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ee2adc9807655a8da4db9df25543da4a434207dc57e4cb57978b84cd1f66ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56a8454c2a1e63e1885b0b2bf5bb885183bf4114799bead05438c218a58476cf"
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
