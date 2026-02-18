class Pomo < Formula
  desc "Terminal Pomodoro Timer"
  homepage "https://github.com/Bahaaio/pomo"
  url "https://github.com/Bahaaio/pomo/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "539e8383ddc12df99d0e5b220325af48189b0ae3910b8530cff95902a50cd3bc"
  license "MIT"
  head "https://github.com/Bahaaio/pomo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c673fdec77a8e3ffde50498647eee45ffae355feebab2e1c8cea048a445bcf32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c673fdec77a8e3ffde50498647eee45ffae355feebab2e1c8cea048a445bcf32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c673fdec77a8e3ffde50498647eee45ffae355feebab2e1c8cea048a445bcf32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f09297e0425736ba3b559012e548c61b55cbbb3fada5303b15fcbb683160e1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce79d055a397bb0517712576d5adad9e73ad365b04a4a170d67feac0d45016a4"
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
