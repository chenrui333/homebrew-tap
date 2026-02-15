class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.12.4.tar.gz"
  sha256 "e1b5eed12504afd7054de019719b724cbb714fa42441ca1afe8e1fa20c69855e"
  license "MIT"
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2140a52f15a58a9aafa9823ac66928a621588323e27abc8db98dc9edf1e08953"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2140a52f15a58a9aafa9823ac66928a621588323e27abc8db98dc9edf1e08953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2140a52f15a58a9aafa9823ac66928a621588323e27abc8db98dc9edf1e08953"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "426055350ed30465ed12c869f6cfa3081179f0cf58c298f14c3ca48f808973dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae5f79ae48212bc75aaba74975f62a61f67d96d48d18cde5bedf41b35b888485"
  end

  depends_on "go" => :build

  def install
    go_version = Formula["go"].version
    ldflags = %W[
      -s -w
      -X main.Tag=v#{version}
      -X main.Commit=v#{version}
      -X main.SourceURL=https://github.com/incu6us/goimports-reviser
      -X main.GoVersion=go#{go_version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # `-version` has other info as GoVersion, source, and commit
    # `-version-only` just prints the version
    assert_match version.to_s, shell_output("#{bin}/goimports-reviser -version-only")

    (testpath/"main.go").write <<~GO
      package main

      import (
        "fmt"
        "os"
      )

      func main() {
        fmt.Println("Hello, World!")
        os.Exit(0)
      }
    GO

    system bin/"goimports-reviser", "-project-name", "main", testpath/"main.go"
    expected_content = <<~GO
      package main

      import (
      \t"fmt"
      \t"os"
      )

      func main() {
      \tfmt.Println("Hello, World!")
      \tos.Exit(0)
      }
    GO

    assert_equal expected_content, (testpath/"main.go").read
  end
end
