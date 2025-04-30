# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.42.tar.gz"
  sha256 "aef30c87d2ebda6a3b322b8c979763789b0591b0e8800a98148212e4fa6c7643"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "639361c15b8ca05669dcbd7807969ebfe9a1a074cd8c139ab451b66a5e5535e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79b8eba5c41ea03208d1f92ababaaaccd2e4f0a7275b63e0db1e78b84035e6fa"
    sha256 cellar: :any_skip_relocation, ventura:       "8e5544c435bcd403643e21c6f047ae3b43f21cfc601e651bf854ccc6b2d7217d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a225b35a72e80e086c8457664aaa0d454302eb0bc039c092f323a952fe64689"
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
