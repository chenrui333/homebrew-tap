class Pomo < Formula
  desc "Terminal Pomodoro Timer"
  homepage "https://github.com/Bahaaio/pomo"
  url "https://github.com/Bahaaio/pomo/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "d13a059310f7d8b07c7b29f378e5d3cab7082f4addafd224c8ee8d9ededa6f0a"
  license "MIT"
  head "https://github.com/Bahaaio/pomo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6462c657510a2bb4601f6096b18b8713245cfdbad365232402dcd75e24698217"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6462c657510a2bb4601f6096b18b8713245cfdbad365232402dcd75e24698217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6462c657510a2bb4601f6096b18b8713245cfdbad365232402dcd75e24698217"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2355a559a707e4798416431eb7ce56211f7dcded1f92e2118c8416bbf3a4da84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31505e8ef549cc94eb4502881bf9e715b021c02d2e22d1d713f7626b27c4f218"
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
