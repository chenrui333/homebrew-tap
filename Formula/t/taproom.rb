class Taproom < Formula
  desc "TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "80609d839488c34c8bf870b70430955fa600266fda16298c79a6c48c529404f0"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45141bbd1ae2b90996eac2ac2408cb3ff912658c578af62ee6947d413fcb2c98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45141bbd1ae2b90996eac2ac2408cb3ff912658c578af62ee6947d413fcb2c98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45141bbd1ae2b90996eac2ac2408cb3ff912658c578af62ee6947d413fcb2c98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "472f70b45522e4faf24c6969d9297423caaed6475943def02893d82f6f51178b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c6c71aeaf1798dbb73a01a664b4c669d7ba0d84ad351bb8abbca433f90dbe6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taproom --version")

    # Skip test on Linux GitHub Actions runners due to TTY issues
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"taproom", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "[1/6] Loading all Formulae...\r\n[2/6] Loading all Casks...", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
