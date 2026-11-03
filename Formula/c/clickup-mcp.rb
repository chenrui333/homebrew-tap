class ClickupMcp < Formula
  desc "MCP Server for ClickUp"
  homepage "https://github.com/hauptsacheNet/clickup-mcp"
  url "https://registry.npmjs.org/@hauptsache.net/clickup-mcp/-/clickup-mcp-1.10.0.tgz"
  sha256 "65389366f815458276ad57daec0dfd051c450e48d1d574245c78250c5cb503ce"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3ea1525facac076b9e7c4fa808339ca10d8a29067912e3ecdc25b6c424d3c5cd"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/clickup-mcp 2>&1", 1)
    assert_match "Missing Clickup API key or team ID", output
  end
end
