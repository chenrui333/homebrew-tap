class Cchistory < Formula
  desc "Like the shell history command but for your Claude Code sessions"
  homepage "https://github.com/eckardt/cchistory"
  url "https://registry.npmjs.org/cchistory/-/cchistory-0.3.0.tgz"
  sha256 "50e69289640349d9100c16e18a1909962ba60ba14a9927efa17c96daa09f40a0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "f56fe6da285edd6b820b060cae725de6e5bfb1e85b791b787ad21981dbbf5633"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cchistory --version")
    output = shell_output("#{bin}/cchistory --list-projects 2>&1", 1)
    assert_match "Cannot access Claude projects directory", output
  end
end
