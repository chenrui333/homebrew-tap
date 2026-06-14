class Freeze < Formula
  desc "Generate images of code and terminal output"
  homepage "https://github.com/charmbracelet/freeze"
  url "https://github.com/charmbracelet/freeze/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "f0e959bc0c83c0a00d9da8362ca0d928191ad3207fc542c757e9eddda4014e08"
  license "MIT"
  head "https://github.com/charmbracelet/freeze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd8601384df73d54dbe3ac7a029846914414c35cea3eceb905c95500bb7700a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd8601384df73d54dbe3ac7a029846914414c35cea3eceb905c95500bb7700a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd8601384df73d54dbe3ac7a029846914414c35cea3eceb905c95500bb7700a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3300c0f52c8a6e6034a372ea0bf07e76472ca2e313dea5fe4e502279c36e533e"
    sha256 cellar: :any,                 x86_64_linux:  "970fafde519f7fdf0661ce9aee584ab3c7317b618a5453ea61c99438cdfc4056"
  end

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

    pipe_output("#{bin}/freeze --language go --output #{testpath}/hello.png", (testpath/"hello.go").read)
    assert_path_exists testpath/"hello.png"
  end
end
