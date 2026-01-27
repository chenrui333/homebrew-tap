class Pomo < Formula
  desc "Terminal Pomodoro Timer"
  homepage "https://github.com/Bahaaio/pomo"
  url "https://github.com/Bahaaio/pomo/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "97961119f6743cf93d5d7134e6453d8b373964a31852f8360704b059f494906a"
  license "MIT"
  head "https://github.com/Bahaaio/pomo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17de16a6572dd76db8bd2d9aaebc676f60ec459195204de2bc9de5d21b37a1c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17de16a6572dd76db8bd2d9aaebc676f60ec459195204de2bc9de5d21b37a1c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17de16a6572dd76db8bd2d9aaebc676f60ec459195204de2bc9de5d21b37a1c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efee79c919e942ccdbe400c380f76470f11f67b3ae7dd161db6bb4304ca68584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9cf371061e83106e32a14ebccc33964ecdf26b58362020b9e925e00e6ac97e8"
  end

  depends_on "go" => :build

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
