class FkillCli < Formula
  desc "Fabulously kill processes. Cross-platform"
  homepage "https://github.com/sindresorhus/fkill-cli"
  url "https://registry.npmjs.org/fkill-cli/-/fkill-cli-8.0.0.tgz"
  sha256 "47be11adbcb1524213aea291a829640c13f93381324fc00bbe059805166da40c"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/fkill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fkill --version")

    pid = spawn "sleep 60"
    sleep 1
    system bin/"fkill", pid.to_s
    assert_equal pid, Process.waitpid(pid, Process::WNOHANG)
  end
end
