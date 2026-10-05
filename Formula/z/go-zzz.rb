# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.51.tar.gz"
  sha256 "445818091dcb6dfe10708d84c9ecfce5e113512368c3bce48b7bce06f55cb95b"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32444f004850133f10cd9bcd266cd5fdd5320768e42d619c829844b16ca18b5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32444f004850133f10cd9bcd266cd5fdd5320768e42d619c829844b16ca18b5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14455e99671f1c5f651b5205308059382f23b513e2816cf67ad6662544596d63"
    sha256 cellar: :any,                 x86_64_linux:  "e91a67eb27bafa47236baa592b4a1ac065efbd345a3b71def8a28290bc486d8e"
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
