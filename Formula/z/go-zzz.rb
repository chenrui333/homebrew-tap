# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.48.tar.gz"
  sha256 "8cb3e2b7922aa0a4d2cb82e5ee90b6faab9b2f904f435183a82e0ff7e37a13d6"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2cd1e6c2a9defa148713dd1e1df99917b7adf8a7af66f31d5bc856e310130e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2cd1e6c2a9defa148713dd1e1df99917b7adf8a7af66f31d5bc856e310130e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2cd1e6c2a9defa148713dd1e1df99917b7adf8a7af66f31d5bc856e310130e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec358497fd4652fac761ffbef6c13bb95fe977e5d7c8c6ac3b02124c2f0d39f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03caa84f063b3355321c2d15df798f640ba0c330ea5ff50929dd7630caef973b"
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
