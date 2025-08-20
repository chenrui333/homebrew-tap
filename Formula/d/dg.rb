class Dg < Formula
  desc "Self-testing CLI documentation tool that generates interactive demos"
  homepage "https://deepguide.ai/"
  url "https://registry.npmjs.org/@deepguide-ai/dg/-/dg-3.1.5.tgz"
  sha256 "1b5eb887fbbff8488d3f19f0b8a5954265a6ad20515d064eda5c18ee9701d66f"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "❌ No config found", shell_output("#{bin}/dg list")
  end
end
