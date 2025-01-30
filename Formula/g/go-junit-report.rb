class GoJunitReport < Formula
  desc "Convert Go test output to JUnit XML"
  homepage "https://github.com/jstemmer/go-junit-report"
  url "https://github.com/jstemmer/go-junit-report/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "6320a11a2a8c564f5a92a44eeae40950246ae5c70b3c679a1e702e128d6e900b"
  license "MIT"
  head "https://github.com/jstemmer/go-junit-report.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b8c7b77ca162d9744e9bbd491ddd30b0d32068f63b86f4d1247aea0cfcc1607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b9668b573f0050d6af9324fb94c99cedff0cb10b491a7c8dd7a32fd77f682f3"
    sha256 cellar: :any_skip_relocation, ventura:       "9c44fb83cd5afc627e775b226bd1a34faefd2bee1d369bd46bfbdf5f0621521d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3aa4837fc94782a27f7295b39b949a7c1539a841adf9f8cc1b89c72add3257"
  end

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
