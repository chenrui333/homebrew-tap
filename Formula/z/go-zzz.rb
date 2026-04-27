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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0be4bd0850049f7d5607bb86bcf745a085e66431517c499e38bc937b6d4619bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0be4bd0850049f7d5607bb86bcf745a085e66431517c499e38bc937b6d4619bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0be4bd0850049f7d5607bb86bcf745a085e66431517c499e38bc937b6d4619bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6e664449e90f507a8cb80a6b2571f99b394bcc148e896c55c72230e870b5c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4417f1e23c627959e07a1b5e817b5c8f99318afa0f4ad321f77fcc5c08705231"
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
