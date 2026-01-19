# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.49.tar.gz"
  sha256 "ec2f11751134dc9083bbe281acc557434b4c3062a1f51859587bf77b792d0707"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a80951a738cb9821910e2b1e8a798201adb1be9540db377c2ec445c3af3007e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a80951a738cb9821910e2b1e8a798201adb1be9540db377c2ec445c3af3007e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a80951a738cb9821910e2b1e8a798201adb1be9540db377c2ec445c3af3007e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ae8f4c38c2f9ffc88bf4a0ac8de8920039bf7c36591096ba67b0d0bdbc33a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64e84cd0249565225fb119e942a9951e6101a8fcd62b47a796a3f6c3319ae442"
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
