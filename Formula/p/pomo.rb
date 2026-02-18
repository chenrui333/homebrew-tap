class Pomo < Formula
  desc "Terminal Pomodoro Timer"
  homepage "https://github.com/Bahaaio/pomo"
  url "https://github.com/Bahaaio/pomo/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "539e8383ddc12df99d0e5b220325af48189b0ae3910b8530cff95902a50cd3bc"
  license "MIT"
  head "https://github.com/Bahaaio/pomo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61df7b35a7c86db505a8ab1b905e8edd4add981b03a8648adbb07205b032e9ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61df7b35a7c86db505a8ab1b905e8edd4add981b03a8648adbb07205b032e9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61df7b35a7c86db505a8ab1b905e8edd4add981b03a8648adbb07205b032e9ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3793f0b2a9c4f3eb4e9bc76346710e98fa5ade2c6ec749eec602891d053b0dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "352616ba4dd3904cd1e872f90b6b1de165e5160f407e709d9bef362d88dfcb5f"
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
