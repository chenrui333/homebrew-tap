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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a90fe5ffe27afc0ef444db146833275e9769ea6d8cc6702940d31b486038c4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650df025123f81b61c2d6e3f0bdbd645e8b6a1abc3ef8c2748213ad057ec82c9"
    sha256 cellar: :any_skip_relocation, ventura:       "9be55fc224faa4e637c59bade5a703959abfe6950cc69fa60feb9b5a35f979af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ca2460ea96affd546e85ce03489dfb187e6be51d3dba056e1af19c89755e8d"
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
