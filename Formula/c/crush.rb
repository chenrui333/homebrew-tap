class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "2e86e2f4ceb1f773f2f610be066e35fcff9773bb5cc80d4a3c6b1a88ce62237f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9aafa3f63b355f22611991bcde780ab1fc68a13afd6ee1750465153a1211a21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9aafa3f63b355f22611991bcde780ab1fc68a13afd6ee1750465153a1211a21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9aafa3f63b355f22611991bcde780ab1fc68a13afd6ee1750465153a1211a21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7c103c17ba857672ca1a78737fd4c7dd1368ca7fdbeda56d4a39f42739b8ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b38ec01b93febce779d0db8d665c4e544200e0c21408ec56a0697d61aedf792a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
