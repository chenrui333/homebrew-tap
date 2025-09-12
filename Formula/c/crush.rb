class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "123e3e7d7ca52787b679b86e212d226264cc64fde892c4f8426a371ed6b95ea3"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "867e0cf7ee55f839200bf944b1541fd1131d7a54c07592feed7cbcf7d2992b0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c8ed701d98c990493f28bb392c156c3aa7ea3850e1061cc46de5a8a156e6a35"
    sha256 cellar: :any_skip_relocation, ventura:       "57561eb472174848b1230c4455e083b48085cb04ab803b84e6e30207e7a9620f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f1d3a0040809e9f3fd28db5fe65de2a828076f2e67c48eab6639512f98999e"
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
