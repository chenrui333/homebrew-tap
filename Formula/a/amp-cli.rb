class AmpCli < Formula
  desc "Coding agent for your terminal and editor, built by Sourcegraph"
  homepage "https://ampcode.com/"
  url "https://registry.npmjs.org/@sourcegraph/amp/-/amp-0.0.1761667293-g539b00.tgz"
  sha256 "63edce81abfbaf6baef54ee2237512069dee150127e81a7b921d5aa16fe3f953"
  # license :unfree

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/amp --version")
    output = shell_output("#{bin}/amp update 2>&1")
    assert_match "Amp CLI is already up to date.", output
  end
end
