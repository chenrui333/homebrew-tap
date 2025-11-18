class Junit2html < Formula
  desc "Convert junit.xml into gorgeous HTML reports"
  homepage "https://github.com/kitproj/junit2html"
  url "https://github.com/kitproj/junit2html/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a9940e248731f63665bb49f5d7b4ca32e612ccb396dc0d78a2515ab388bf0be9"
  license "MIT"
  head "https://github.com/kitproj/junit2html.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2490a110ec7921ae1a420cbc1d867d07a74e615a0da0205eef21657c9a321e03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2490a110ec7921ae1a420cbc1d867d07a74e615a0da0205eef21657c9a321e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2490a110ec7921ae1a420cbc1d867d07a74e615a0da0205eef21657c9a321e03"
    sha256 cellar: :any_skip_relocation, sequoia:       "d4e9fef94797ec1bdbd531267dfb32de50609bf31bbd63349bb4242916f60cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d5d34fbdef2bb3dc63401f1d9196ab3a289f2e374eda7e9264e5b078ad5bc76"
  end

  depends_on "go" => [:build, :test]
  depends_on "go-junit-report" => :test # this is from the same tap

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
