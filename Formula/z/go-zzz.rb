# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.46.tar.gz"
  sha256 "9a0c7e7103fc5b5ba51a35c9765c1a72152602b86050c51f5eb87fd95e9873ae"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a6cef956ebd913b55b76e0246f770dfd5acdb2c49b47952189e47117a0eef31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "909650a0f190f36c813560285b7d1fd69d2131b81dec9883767f6f2fc22ac574"
    sha256 cellar: :any_skip_relocation, ventura:       "ba1b55d4fd843373ed585f145e93c814eb220c7b6fa673bc20f1dd9f2344576b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63bfde1690253d4ee5807e74d0c3f2e44b351ed60a408deba1c1f388ad7f9676"
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
