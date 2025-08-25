class Dxt < Formula
  desc "MCP server for Shadcn UI v4"
  homepage "https://github.com/anthropics/dxt"
  url "https://registry.npmjs.org/@anthropic-ai/dxt/-/dxt-0.2.6.tgz"
  sha256 "d98427c2178d80d4da6f27a8255c2dbb40da9c59c7c232181435a7e253f3c40e"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dxt --version")

    output = shell_output("#{bin}/dxt init --yes .")
    assert_match "Creating manifest.json with default values...", output
    assert_equal "A DXT extension", JSON.parse((testpath/"manifest.json").read)["description"]
  end
end
