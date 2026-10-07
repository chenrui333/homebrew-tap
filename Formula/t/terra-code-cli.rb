class TerraCodeCli < Formula
  desc "AI-powered development companion with persistent memory and knowledge"
  homepage "https://github.com/TerraAGI/terra-code-cli"
  url "https://registry.npmjs.org/@terra-code/terra-code/-/terra-code-0.2.0.tgz"
  sha256 "4bf515dbcc31afacd00d7a0de5870246ae6c4301a73ba9c0c7d319412298ed6a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ec420693fe005c3e690119a3af3a246b1bba549f7047545227f1cb39e211f2cd"
    sha256 cellar: :any,                 arm64_sequoia: "ec420693fe005c3e690119a3af3a246b1bba549f7047545227f1cb39e211f2cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f77d516351fb487ee5500d7c65508a6311edf0f7294fc037cf0e8506509e71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f77d516351fb487ee5500d7c65508a6311edf0f7294fc037cf0e8506509e71a"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args, "--ignore-scripts"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terra --version")
    assert_match "No MCP servers configured", shell_output("#{bin}/terra mcp list")
  end
end
