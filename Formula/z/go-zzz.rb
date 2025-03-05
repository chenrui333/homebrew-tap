# framework: cobra
class GoZzz < Formula
  desc "Hot compilation of Go programs, stress testing for Golang development"
  homepage "https://github.com/sohaha/zzz"
  url "https://github.com/sohaha/zzz/archive/refs/tags/v1.0.40.tar.gz"
  sha256 "c01cec76bc188a7ad627ae85f05a7136121555fb9b3c8f4646c9da1895e7c5d5"
  license "Apache-2.0"
  head "https://github.com/sohaha/zzz.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30a2c3ab842f93307ad91e2863cfa364a2be8b26a73c4006736d4ed93cff6dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd8e1aca5997517fa797bbb9e2b824a14b45caf1b8fb2633ad8d8626f67d96ac"
    sha256 cellar: :any_skip_relocation, ventura:       "eced6a13676bff0658472d660199e19bc9a50243fb90af55697f03068669bc60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb87b8e6103a7a6256f5bd0ffd16cb21ae3c4c5b78b238b2fced2e96bcc3d2a4"
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
