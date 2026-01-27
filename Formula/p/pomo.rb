class Pomo < Formula
  desc "Terminal Pomodoro Timer"
  homepage "https://github.com/Bahaaio/pomo"
  url "https://github.com/Bahaaio/pomo/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "97961119f6743cf93d5d7134e6453d8b373964a31852f8360704b059f494906a"
  license "MIT"
  head "https://github.com/Bahaaio/pomo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0d399297dab56d3e61d06d51413c47def03e8e682ca86721a556c270c7d342d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d399297dab56d3e61d06d51413c47def03e8e682ca86721a556c270c7d342d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0d399297dab56d3e61d06d51413c47def03e8e682ca86721a556c270c7d342d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "435927025945423d4930b3aa47e59e7ce02316fb4c9501a743d4784be18dc1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3feecdb5f6a93a3aa06b8459e1bffde6732f20557d9e1a2dd8476e64fdf87806"
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
