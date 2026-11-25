class CopilotCli < Formula
  desc "Copilot coding agent directly to your terminal"
  homepage "https://github.com/github/copilot-cli"
  url "https://registry.npmjs.org/@github/copilot/-/copilot-1.0.115.tgz"
  sha256 "17d96176873627a1f270dd4e874a1dcdf76211b47607b8db537ec97117ab4699"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "3139b483608638bdea800f481e8c4ba7c44f6bc233493922bfb2ab947d1931a1"
    sha256 cellar: :any_skip_relocation, all: "54833ea7d8b42b6ddb84a83c93da35603cfb2afdf6958b8294a72c03a0fe95ae"
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
