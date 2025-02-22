class FkillCli < Formula
  desc "Fabulously kill processes. Cross-platform"
  homepage "https://github.com/sindresorhus/fkill-cli"
  url "https://registry.npmjs.org/fkill-cli/-/fkill-cli-8.0.0.tgz"
  sha256 "47be11adbcb1524213aea291a829640c13f93381324fc00bbe059805166da40c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b916aa293073304ac5a729d15c5d0be89322eb51489110255a3daf495997e82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d1e0d8934269079497df4a256f31696b52e7d628d3b4b395d7ae1b9f895cba2"
    sha256 cellar: :any_skip_relocation, ventura:       "e4aa228c1acf75319175b95f56b58b95d64eded921761fcc8812c8cd8b95862b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5987db01cd87dc1442c1d7cc6b898a57de36ba8755971b27e15e3722daef3656"
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
