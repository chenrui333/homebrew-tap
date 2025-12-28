class Pomo < Formula
  desc "Terminal Pomodoro Timer"
  homepage "https://github.com/Bahaaio/pomo"
  url "https://github.com/Bahaaio/pomo/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "42b0414334afbf03125c7b04e1dcad1d0cb9f6eb1342d54f95ff55e3f5ae2f3d"
  license "MIT"
  head "https://github.com/Bahaaio/pomo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd16b4aeee783f3127c68b7ec79c296b82ef96f5ac7ac718aa94acea3b794721"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd16b4aeee783f3127c68b7ec79c296b82ef96f5ac7ac718aa94acea3b794721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd16b4aeee783f3127c68b7ec79c296b82ef96f5ac7ac718aa94acea3b794721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5f6f580566930defe36a50c6762fdc1ab4655268a8444eb5e4c92853090d284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6591848174f6dcbd124f028252817cb759e47b63f6bde99fa5e0f12575573fd"
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
