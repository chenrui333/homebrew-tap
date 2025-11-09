class FkillCli < Formula
  desc "Fabulously kill processes. Cross-platform"
  homepage "https://github.com/sindresorhus/fkill-cli"
  url "https://registry.npmjs.org/fkill-cli/-/fkill-cli-9.0.0.tgz"
  sha256 "e92e858097abefc2c1438fb0aceeae86a4f7059034c28fb483efaa762ba45cb2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "48af16649f0abe0865f59ef9573a1e705fba9ab03956d3920690076bbc3b5f9a"
  end

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
