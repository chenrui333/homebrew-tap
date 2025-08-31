class Cchistory < Formula
  desc "Like the shell history command but for your Claude Code sessions"
  homepage "https://github.com/eckardt/cchistory"
  url "https://registry.npmjs.org/cchistory/-/cchistory-0.2.0.tgz"
  sha256 "151b7194d3643b5a321b0650d31a73912fbae02c382707c61650da7194ec6611"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cchistory --version")
    output = shell_output("#{bin}/cchistory --list-projects 2>&1", 1)
    assert_match "Cannot access Claude projects directory", output
  end
end
