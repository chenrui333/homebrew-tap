class HappyCoder < Formula
  desc "Command-line interface for Claude Code and Codex"
  homepage "https://github.com/slopus/happy-cli"
  url "https://registry.npmjs.org/happy-coder/-/happy-coder-0.13.0.tgz"
  sha256 "dee16a2425db6aa9db3bf017978075c8ec0984b971a864f6bfdaf7b58cc5a08c"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/happy doctor 2>&1")
    assert_match "Happy CLI Version: #{version}", output
    assert_match "Doctor diagnosis complete!", output
  end
end
