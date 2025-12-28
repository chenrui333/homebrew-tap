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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "109281d26d65ec468a7cbf398da97ec6d7423e0fbcdea3be4dc1a37107f5cd1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f713eeea9dd40ebcd8498f1767ba923a7936e32d1ff130011d684a103d8be829"
    sha256 cellar: :any_skip_relocation, ventura:       "c285eb8c6ed4b9db0c01f572b763f4e3446ddaa8360a9eacd21e44cc70202f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3dfaefbffbcedea2d48173c241d6b66acf92e6d0b144cf583b18566c9228f85"
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
