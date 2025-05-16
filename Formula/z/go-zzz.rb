# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.43.tar.gz"
  sha256 "8ef04c1584adde65700d94e7bf37128582ef691b7f2caa1b64e70b54e1474480"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ffcde77a2a2524b98b3798843997b53b071840c044eb48ee172108aa99989c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a435273bb0ab9c4fe9e3bf56a4c9626177fa1d366eacea5fdd20a1f5842fa5c"
    sha256 cellar: :any_skip_relocation, ventura:       "01c3354593b15f5d8b27cfad71573592a69cbd1f35c99e96792e3221db04a5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f37e2e07f1ea3ead25d38ac98e80264fc78492f97d107e0ad3cbe7bd9b97d7"
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
