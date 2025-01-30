class Junit2html < Formula
  desc "Convert junit.xml into gorgeous HTML reports"
  homepage "https://github.com/kitproj/junit2html"
  url "https://github.com/kitproj/junit2html/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d4155f4c79cc1db9140eb7851b14554bdcac4f92b815628c10a4162449619ab0"
  license "MIT"
  head "https://github.com/kitproj/junit2html.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47a633c105f7e589e583531397a2b635b2de9fb143422d6e34923dd0cc52b3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fad1a3e2cfbbbaf91666a9330012acb9159e05a215ac7eda94c43da025e581d2"
    sha256 cellar: :any_skip_relocation, ventura:       "936febd8ff387f567f92a97e6611cc81b29c9a8a2b57d7516df97565edbabdae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5fc49742e25f874959b4b03633aa00b7d1c6b0d158a86ef311ad2c018bdb233"
  end

  depends_on "go" => [:build, :test]
  depends_on "go-junit-report" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module github.com/Homebrew/brew-test

      go 1.18
    GOMOD

    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func Hello() string {
        return "Hello, gotestsum."
      }

      func main() {
        fmt.Println(Hello())
      }
    GO

    (testpath/"main_test.go").write <<~GO
      package main

      import "testing"

      func TestHello(t *testing.T) {
        got := Hello()
        want := "Hello, gotestsum."
        if got != want {
          t.Errorf("got %q, want %q", got, want)
        }
      }
    GO

    shell_output("go test -v -cover ./... 2>&1 > test.out")
    shell_output("go-junit-report < test.out > junit.xml")
    shell_output("#{bin}/junit2html < junit.xml > test-report.html")
  end
end
