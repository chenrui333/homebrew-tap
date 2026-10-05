class Junit2html < Formula
  desc "Convert junit.xml into gorgeous HTML reports"
  homepage "https://github.com/kitproj/junit2html"
  url "https://github.com/kitproj/junit2html/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a9940e248731f63665bb49f5d7b4ca32e612ccb396dc0d78a2515ab388bf0be9"
  license "MIT"
  head "https://github.com/kitproj/junit2html.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "885b89ad42a6a91c0f8137bcca7e088de4c9928703368b4266e2611d957841a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "885b89ad42a6a91c0f8137bcca7e088de4c9928703368b4266e2611d957841a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54596acda8a2efb1c7d9b5c1005237d530fdfb8dc9453079140e3732418f0d11"
  end

  depends_on "go" => [:build, :test]
  depends_on "go-junit-report" => :test # this is from the same tap

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
