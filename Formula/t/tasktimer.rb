class Tasktimer < Formula
  desc "Dead simple TUI task timer"
  homepage "https://github.com/caarlos0/tasktimer"
  url "https://github.com/caarlos0/tasktimer/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "73cca9d35b2a25ea4407baebab1ee0a446fe1bc8492832db1ca781f9e22757b3"
  license "MIT"
  head "https://github.com/caarlos0/tasktimer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8e39f62e2360bb91be295c927c5ff544df571c98b2df41d4464de4a93df5a62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8e39f62e2360bb91be295c927c5ff544df571c98b2df41d4464de4a93df5a62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb4d0cb0b2a94be94ad3393dae03434800d23951b8c1de39e65196f6345dbe49"
    sha256 cellar: :any,                 x86_64_linux:  "600158f90574c62ba2f0a131cb6a5a59fe2f9e19680faeedf71643690a388cf0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
