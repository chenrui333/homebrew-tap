class Pomo < Formula
  desc "Terminal Pomodoro Timer"
  homepage "https://github.com/Bahaaio/pomo"
  url "https://github.com/Bahaaio/pomo/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "d13a059310f7d8b07c7b29f378e5d3cab7082f4addafd224c8ee8d9ededa6f0a"
  license "MIT"
  head "https://github.com/Bahaaio/pomo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9bd389898811831ce93c495cbd4d8c32a918b4a3394515d4617707753eb114b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9bd389898811831ce93c495cbd4d8c32a918b4a3394515d4617707753eb114b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0420124efbe169eedc2bc7668730c669cd8c21a783fe203764130eca416f7f1c"
    sha256 cellar: :any,                 x86_64_linux:  "6b51527885760d41ec021a25235e81f96aea947f0400793349182255430e5991"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"pomo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pomo --version")

    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"pomo", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "work session", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
