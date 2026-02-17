class Branchlet < Formula
  desc "Simple CLI Git worktree manager"
  homepage "https://github.com/raghavpillai/branchlet"
  url "https://registry.npmjs.org/branchlet/-/branchlet-0.1.3.tgz"
  sha256 "7bf09b0d73111df542e334d5230f0997a2fac95d86c4ae410764c6f2540690cc"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/branchlet --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"branchlet", "list", [:out, :err] => output_log.to_s
    sleep 3
    assert_match "🌳 Branchlet - List", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
