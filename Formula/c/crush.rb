class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "5e514ac32cfefac8aaec8f14048650ac50860ff0113765a075a9d5642e7a668a"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74173c5935d023544958b09f73a3cd263b5fa0c4ecc4b0f33be642dac41a2413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74173c5935d023544958b09f73a3cd263b5fa0c4ecc4b0f33be642dac41a2413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74173c5935d023544958b09f73a3cd263b5fa0c4ecc4b0f33be642dac41a2413"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bda0469e0a280cc102b95b6c2ea2bf441ad9bed43eb52e3b25c31ade1c9f1296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0fe4cea09dc7b2a385502ce7a7c775608c5cfa6bcf6d068bf6f4d0aff1bb5ae"
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
