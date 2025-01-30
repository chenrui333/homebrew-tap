class Junit2html < Formula
  desc "Convert junit.xml into gorgeous HTML reports"
  homepage "https://github.com/kitproj/junit2html"
  url "https://github.com/kitproj/junit2html/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d4155f4c79cc1db9140eb7851b14554bdcac4f92b815628c10a4162449619ab0"
  license "MIT"
  head "https://github.com/kitproj/junit2html.git", branch: "main"

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
