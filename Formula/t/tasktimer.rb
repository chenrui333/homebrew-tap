class Tasktimer < Formula
  desc "Dead simple TUI task timer"
  homepage "https://github.com/caarlos0/tasktimer"
  url "https://github.com/caarlos0/tasktimer/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "73cca9d35b2a25ea4407baebab1ee0a446fe1bc8492832db1ca781f9e22757b3"
  license "MIT"
  head "https://github.com/caarlos0/tasktimer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7423695d29ff6f93744ecd727203012371c9a4c7d2ff327b63e546abd489594b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7423695d29ff6f93744ecd727203012371c9a4c7d2ff327b63e546abd489594b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7423695d29ff6f93744ecd727203012371c9a4c7d2ff327b63e546abd489594b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32b4cbb01f332d3e56cf7b615fe0b04aaeeb699710a827c87633da99a1ed9cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8704793ceb1dfb00610690327fc7ba65ad9536ce2ebd800b66065b8e02ad8b68"
  end

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
