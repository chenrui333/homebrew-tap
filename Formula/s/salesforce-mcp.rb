class SalesforceMcp < Formula
  desc "MCP Server for interacting with Salesforce instances"
  homepage "https://github.com/salesforcecli/mcp"
  url "https://registry.npmjs.org/@salesforce/mcp/-/mcp-0.21.3.tgz"
  sha256 "a30fe654f68af12ffed3d11f82eacd28a0cf0303d6f2b21af14a2f3464a7db07"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8391ebada56de79d95debd6f51aa362b7a50ff3a51b800a8d9f57b7125d0735a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24cd17f3d6cca6f4575a9a6bd207e7d5f238eaa8fa3ae3b248f9f503b09f9a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf0c3b50fb1d3d235d333acbc93207aa1b4d62d059cdf05343c986343483944c"
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
