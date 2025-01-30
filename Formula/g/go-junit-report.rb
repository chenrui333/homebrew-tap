class GoJunitReport < Formula
  desc "Convert Go test output to JUnit XML"
  homepage "https://github.com/jstemmer/go-junit-report"
  url "https://github.com/jstemmer/go-junit-report/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "6320a11a2a8c564f5a92a44eeae40950246ae5c70b3c679a1e702e128d6e900b"
  license "MIT"
  head "https://github.com/jstemmer/go-junit-report.git", branch: "master"

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Revision=#{tap.user}
      -X main.BuildTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-junit-report --version")

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
    shell_output("#{bin}/go-junit-report < test.out > junit.xml")
  end
end
