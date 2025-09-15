class Heyagent < Formula
  desc "Claude Code notifications"
  homepage "https://www.heyagent.dev/"
  url "https://registry.npmjs.org/heyagent/-/heyagent-0.0.4.tgz"
  sha256 "d3da7e5332789d1d46121fa79f175bfe7b06c73d2046573a3c7c49273869c378"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hey --version")
    assert_match "HeyAgent notifications enabled", shell_output("#{bin}/hey on")
  end
end
