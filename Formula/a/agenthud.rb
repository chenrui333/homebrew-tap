class Agenthud < Formula
  desc "Claude Code TUI dashboard for parallel sessions and sub-agents"
  homepage "https://github.com/neochoon/agenthud"
  url "https://registry.npmjs.org/agenthud/-/agenthud-0.18.3.tgz"
  sha256 "c854463bb7c376f1b5e789937628c65f543ceb2b046af3ef20f5fd1b50bc2820"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agenthud --version")

    output = shell_output("#{bin}/agenthud report --format json")
    assert_match "format=json", output
    assert_match '"sessions": []', output
  end
end
