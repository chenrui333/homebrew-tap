class Branchlet < Formula
  desc "Simple CLI Git worktree manager"
  homepage "https://github.com/raghavpillai/branchlet"
  url "https://registry.npmjs.org/branchlet/-/branchlet-0.1.2.tgz"
  sha256 "95a11b1dad125862c896edbef30e5794375c3993a45697cc49c4b14dc050d23c"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/branchlet --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "invalid"

    (testpath/".branchlet.json").write <<~JSON
      {
        "worktreesDir": "#{testpath}/worktrees"
      }
    JSON

    output_log = testpath/"output.log"
    pid = spawn bin/"branchlet", "list", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "No additional worktrees found", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
