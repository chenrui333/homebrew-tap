class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.1.8.tgz"
  sha256 "2b47e170e6523e0e64bfdb21620b13175200e4edee6b80342fe38ea65ed38d54"
  license "Apache-2.0"

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpc --version")
    output = shell_output("#{bin}/mcpc tools-list 2>&1", 1)
    assert_match "[McpClient:mcpc] Failed to connect", output
  end
end
