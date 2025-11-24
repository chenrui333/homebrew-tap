class GoimportsReviser < Formula
  desc "Right imports sorting & code formatting tool (goimports alternative)"
  homepage "https://github.com/incu6us/goimports-reviser"
  url "https://github.com/incu6us/goimports-reviser/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "7e28046f91db18f56b0059907249dae4d9fef6784c0c6ae65314d71b6fb77824"
  license "MIT"
  head "https://github.com/incu6us/goimports-reviser.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b52d2c752506fa794880feb122ee778e627744b6fbfe70519c546a2889232151"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b52d2c752506fa794880feb122ee778e627744b6fbfe70519c546a2889232151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b52d2c752506fa794880feb122ee778e627744b6fbfe70519c546a2889232151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edbdd32cf662213f51148142733de9e2a3962a028b65e206deb2e12da9cfbdd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "026a6c8418ec1c45e5a11f39f3bea70ae06c2291df99a45f461ab63aeecab103"
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
