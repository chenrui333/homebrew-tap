class TerraCodeCli < Formula
  desc "AI-powered development companion with persistent memory and knowledge"
  homepage "https://github.com/TerraAGI/terra-code-cli"
  url "https://registry.npmjs.org/@terra-code/terra-code/-/terra-code-0.1.4.tgz"
  sha256 "774f6976f9b3b5664a8ff5e5f711b3f1080cafe4a12f1ad9689fcf240741d8a6"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terra --version")
    assert_match "No MCP servers configured", shell_output("#{bin}/terra mcp list")
  end
end
