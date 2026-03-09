class Tasktimer < Formula
  desc "Dead simple TUI task timer"
  homepage "https://github.com/caarlos0/tasktimer"
  url "https://github.com/caarlos0/tasktimer/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "73cca9d35b2a25ea4407baebab1ee0a446fe1bc8492832db1ca781f9e22757b3"
  license "MIT"
  head "https://github.com/caarlos0/tasktimer.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"tt"), "."
    generate_completions_from_executable(bin/"tt", shell_parameter_format: :cobra, shells: [:bash, :zsh, :fish])
    (man1/"tt.1").write Utils.safe_popen_read(bin/"tt", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt --version")
    assert_equal "null", shell_output("HOME=#{testpath} #{bin}/tt to-json").strip
    assert_match "- default", shell_output("HOME=#{testpath} #{bin}/tt list")
  end
end
