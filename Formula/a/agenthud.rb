class Agenthud < Formula
  desc "Claude Code TUI dashboard for parallel sessions and sub-agents"
  homepage "https://github.com/neochoon/agenthud"
  url "https://registry.npmjs.org/agenthud/-/agenthud-0.18.3.tgz"
  sha256 "c854463bb7c376f1b5e789937628c65f543ceb2b046af3ef20f5fd1b50bc2820"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "7dff8ce862ea158e53b0c6335374a95b83688a0e04d747d81d1f22ffb4412ec3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agenthud --version")

    output = shell_output("#{bin}/agenthud report --format json")
    assert_match '"date":', output
    assert_match '"sessions": []', output
  end
end
