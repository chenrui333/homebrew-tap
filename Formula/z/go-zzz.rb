# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.52.tar.gz"
  sha256 "437b0be178fb3bd943920e8d3ba141d086ac6ab9105cf7b91854e7107d7d1cba"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c12f2dc7b7c845367433fed7f8e953e780b0df1efbe2ccfd80f91e1717be60e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c12f2dc7b7c845367433fed7f8e953e780b0df1efbe2ccfd80f91e1717be60e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "027efb3141942351c6b5bc6aa14b827b8e3e24a05970104c564f2808e65462db"
    sha256 cellar: :any,                 x86_64_linux:  "2a71cfd774f1826e487d30b2aa51a74fea7d14510ad6fe5fa973b55302cc2c59"
  end

  depends_on "go"

  conflicts_with "zzz", because: "both install `zzz` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
