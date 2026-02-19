class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.1.9.tgz"
  sha256 "bbbac55cb86970d506357fa3c1eba32161eefc7a48a64e202e9ee8778862aeeb"
  license "Apache-2.0"

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "glib"
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
