class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "4708663cac163b59fd89928f21a40cfebeb59149531fa4ccece594a26fa138c1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0822ba54e5bf5bdf12164b40d8f6f840012a68b4356053464ccec5beedb11ce6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0822ba54e5bf5bdf12164b40d8f6f840012a68b4356053464ccec5beedb11ce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0822ba54e5bf5bdf12164b40d8f6f840012a68b4356053464ccec5beedb11ce6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba7fb06c13a3dc6574b552c1e80c0b2242e27d7817d89f6a9dd4c65ceb09a1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7670d7a13293a34b25295417bd3200cd6532a06f70cf19de5a5104f6cea8e7e"
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
