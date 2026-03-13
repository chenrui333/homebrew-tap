class Pomo < Formula
  desc "Terminal Pomodoro Timer"
  homepage "https://github.com/Bahaaio/pomo"
  url "https://github.com/Bahaaio/pomo/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "d13a059310f7d8b07c7b29f378e5d3cab7082f4addafd224c8ee8d9ededa6f0a"
  license "MIT"
  head "https://github.com/Bahaaio/pomo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e06b07451a1e1ff621a3f50350bf1b9351f554a3f3e9d1107c22d3b51a704c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e06b07451a1e1ff621a3f50350bf1b9351f554a3f3e9d1107c22d3b51a704c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e06b07451a1e1ff621a3f50350bf1b9351f554a3f3e9d1107c22d3b51a704c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48791a35b2de14be657f562939113e8c07441436f89f0126b39bae5001242706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc77531b236fea8b79ab1e6146226fee22dfcdb85182792a56aa33636237620"
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
