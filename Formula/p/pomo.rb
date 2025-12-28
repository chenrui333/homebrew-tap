class Pomo < Formula
  desc "Terminal Pomodoro Timer"
  homepage "https://github.com/Bahaaio/pomo"
  url "https://github.com/Bahaaio/pomo/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "42b0414334afbf03125c7b04e1dcad1d0cb9f6eb1342d54f95ff55e3f5ae2f3d"
  license "MIT"
  head "https://github.com/Bahaaio/pomo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6b06e073794d6a6791238cf2e8df52e80399ceb219027433f7870cf7b85fada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6b06e073794d6a6791238cf2e8df52e80399ceb219027433f7870cf7b85fada"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b06e073794d6a6791238cf2e8df52e80399ceb219027433f7870cf7b85fada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6173c80e8ba03c735bf12f79bac194bff75fb239dcd15f85fe609ee7b904e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e553c780e59912445b664dab08fcbed114af35fca35592f67462011ec5633c4"
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
