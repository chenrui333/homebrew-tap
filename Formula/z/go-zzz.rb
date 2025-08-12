# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.45.tar.gz"
  sha256 "e9a2d8d646bedce765a28434e2d56991c50fc39fcb795e55f8aea3d9ba1eb3fc"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfad56a5ae8c1bbf70fc71806798402aecc75d4a35163245289288143c49e5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39e234f27afa8abc5fae1d8fca473e8bdc0cec36eaeb1fb3b02d7ba3ab13ad45"
    sha256 cellar: :any_skip_relocation, ventura:       "00550f5945b862db4b38645ead1f20542fadc568da375e6857acd5af9a8026f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb3ddd1d350bef6037a47ad8d8286837ab2c7d61b82c9b4a1e7968aaf1a6883d"
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
