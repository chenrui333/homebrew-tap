# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.43.tar.gz"
  sha256 "8ef04c1584adde65700d94e7bf37128582ef691b7f2caa1b64e70b54e1474480"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "438659db94beb9bf1413f0e6b46a71987e7e79e340bcfbc197c34e3e40cc04bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a258a845af872008c9b3b33a276554ba5a9ec414877fd5f42e22cc4c158fced0"
    sha256 cellar: :any_skip_relocation, ventura:       "09e586c48dfc6e2910f4304b4a17399d66daab7b5e3a219d5173afd9923c3480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af985fe360ea0739e894c5e8c143fd872c0195e80974ddae83cbe08cd923f5d2"
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

    generate_completions_from_executable(bin/"zzz", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zzz --version")
    assert_match "Zzz one-click installation command", shell_output("#{bin}/zzz more")

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
