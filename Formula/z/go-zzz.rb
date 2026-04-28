# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.50.tar.gz"
  sha256 "8b8f827f62e3eb146302aa777715d29552e73132ef9d64d1962bfe7094e1172c"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27e28f2e0608c6e05a93be732eeeac366f46982580e6686b1da40dd09ac5fb62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27e28f2e0608c6e05a93be732eeeac366f46982580e6686b1da40dd09ac5fb62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27e28f2e0608c6e05a93be732eeeac366f46982580e6686b1da40dd09ac5fb62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98a0c6c3bb021f681d9800918d515a121c20f8e724760209672358bfce6934cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1f60c80182ce11237ca4a86ab3c73f23b91409adbb9a57d98ca42f3e49aec5d"
  end

  depends_on "go"

  conflicts_with "zzz", because: "both install `zzz` binaries"

  def install
    ldflags = %W[
      -s -w
      -X 'github.com/sohaha/zzz/util.BuildTime=#{time.iso8601}'
      -X 'github.com/sohaha/zzz/util.Version=#{version}'
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"zzz")

    generate_completions_from_executable(bin/"zzz", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zzz --version")
    assert_match "zzz more [flags]", shell_output("#{bin}/zzz more")

    system "go", "mod", "init", "brewtest"

    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, world!")
      }
    EOS

    system bin/"zzz", "build", "--", "-o", "main"
    assert_match "Hello, world!", shell_output("./main")
  end
end
