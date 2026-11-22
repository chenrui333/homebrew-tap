class CopilotCli < Formula
  desc "Copilot coding agent directly to your terminal"
  homepage "https://github.com/github/copilot-cli"
  url "https://registry.npmjs.org/@github/copilot/-/copilot-1.0.114.tgz"
  sha256 "d5fd707c2b5b86885c85403ad64b52ae4cb83b49fc498b48020531e47e22de80"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "4c88b6f386dc1a6d769f8fa95731641ce5356678d24020a8b42eb823be4b46ed"
    sha256 cellar: :any_skip_relocation, all: "3700d00f777efbae9d46b74021fb2e600eb8c323e857dacc8ba023451e0d623f"
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
