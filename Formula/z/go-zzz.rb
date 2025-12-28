# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.47.tar.gz"
  sha256 "bf3bed039b16ce06cf11d489652858b9cfb89d35447875ff4e21aa1fcebc1088"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27bbac00cb84a69cc6f7a65699291ffb1ed4693a849ee4d8fab8bf8bedaf2bad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27bbac00cb84a69cc6f7a65699291ffb1ed4693a849ee4d8fab8bf8bedaf2bad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27bbac00cb84a69cc6f7a65699291ffb1ed4693a849ee4d8fab8bf8bedaf2bad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdcba0fa598b6ffeb589272049e6ddfe257b9c81de4cb110c0ccba80d5f74c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641fd4782bc9717e7d3774e8916b649ca69f720cef25bbcd93c71d14ca52daef"
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
