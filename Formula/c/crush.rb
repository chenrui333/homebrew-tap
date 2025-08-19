class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "b2a624bff149c8da50a32c6cdef7757ac7b4f348fbb1f1d3a2fc10f0311886ec"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "655f77d820d3f205b63102854bb3f6cb8505a600670d71d0af413aef72dfcfb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4deb7c00f66878a17103cc7c5ac40dacacc8447d7410473108d1ed2eb3a16089"
    sha256 cellar: :any_skip_relocation, ventura:       "58eafd301908be56692b6d94f05694d18531be6ec3862f22e3ea4314bf8a82ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7bc6c1fb4845e65058e20459852fa511d5164f404243c7f2e395e62479f43f"
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
    assert_match "no providers configured", output
  end
end
