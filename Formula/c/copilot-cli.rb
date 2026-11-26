class CopilotCli < Formula
  desc "Copilot coding agent directly to your terminal"
  homepage "https://github.com/github/copilot-cli"
  url "https://registry.npmjs.org/@github/copilot/-/copilot-1.0.116.tgz"
  sha256 "7610c2af3325bad558ca7db62de5608e41fdac73bf519d62d6f451de7d8fe94a"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e2ea0e6cfe3a5fe717726a0eea2eb768d3d64c81402d3ccac26dfbc744d2db7a"
    sha256 cellar: :any_skip_relocation, all: "27c45f120f2899781bfab2cd27e8cfa6ba953482a546f67bb02b6c2fbe3789af"
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
