class Freeze < Formula
  desc "Generate images of code and terminal output"
  homepage "https://github.com/charmbracelet/freeze"
  url "https://github.com/charmbracelet/freeze/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "f0e959bc0c83c0a00d9da8362ca0d928191ad3207fc542c757e9eddda4014e08"
  license "MIT"
  head "https://github.com/charmbracelet/freeze.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=brew"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeze --version")

    (testpath/"hello.go").write <<~GO
      package main
      import "fmt"
      func main() {
        fmt.Println("Hello, World!")
      }
    GO

    system bin/"freeze", testpath/"hello.go", "--language", "go", "--output", testpath/"hello.png"
    assert_path_exists testpath/"hello.png"
  end
end
