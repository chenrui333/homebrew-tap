class McpServerCloudflare < Formula
  desc "Cloudflare MCP Server"
  homepage "https://github.com/cloudflare/mcp-server-cloudflare"
  url "https://registry.npmjs.org/@cloudflare/mcp-server-cloudflare/-/mcp-server-cloudflare-0.2.0.tgz"
  sha256 "38ac732f0a1264dc05e4db8c2ceef3be59f8855580a77fd5f71af2962d8ab0f9"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No config file found", shell_output("#{bin}/mcp-server-cloudflare run 111 2>&1")
  end
end
