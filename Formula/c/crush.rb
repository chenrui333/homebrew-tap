class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "8d7b6a1f6000e21831a99e7b57c8a1a9ee52ceba0dbd35ceef5490ef8214b623"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2b01515643e5218876ed103b0183a9133c27b7c098e6f1c8bafa88d8797e259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2b01515643e5218876ed103b0183a9133c27b7c098e6f1c8bafa88d8797e259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2b01515643e5218876ed103b0183a9133c27b7c098e6f1c8bafa88d8797e259"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8e2a2f4910193fafba8010a8cd653982ef697c1b02ddd59ff75cdbac4cd0e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84717cd841eeb4a1b553ca4709264b0a9de100da1093090f54cfe4390fb8cf11"
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
