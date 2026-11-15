class CopilotCli < Formula
  desc "Copilot coding agent directly to your terminal"
  homepage "https://github.com/github/copilot-cli"
  url "https://registry.npmjs.org/@github/copilot/-/copilot-1.0.112.tgz"
  sha256 "ab65647d98b77e92442ce6cdbe0ab4c352742e84e1aeeaf28cad77823639e6ef"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "abb79764313faad28bba1e9e22f760bedfa06661cedefe2e11e5c09bac2d8d6a"
    sha256 cellar: :any, arm64_sequoia: "97abeee01e2886a93fd9adfcd84df780fe2babc9131689629149c27ae310577a"
    sha256 cellar: :any, arm64_sonoma:  "97abeee01e2886a93fd9adfcd84df780fe2babc9131689629149c27ae310577a"
  end

  depends_on :macos # TODO: add linux support
  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/copilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/copilot --version")

    output = shell_output("#{bin}/copilot -p 'Fix the bug in main.js' --allow-all-tools 2>&1", 1)
    assert_match "Error: No authentication information found", output
  end
end
