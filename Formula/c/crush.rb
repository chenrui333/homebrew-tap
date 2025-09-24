class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "74405f02cf0592f045be7138d7501b519e45d53c4e806a2583c2f8955a075240"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd8e4d085fba696a83e7a835d2a2eb734170a17dfac603c0c43564b48d1433e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2a987f19c4ad217a2448e5b2168a91f51496357d4305ae706b2add03b279bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebe5fcceae127281b83ec483b89e0a661764dec1fc1360cf0d849ae53f77174b"
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
