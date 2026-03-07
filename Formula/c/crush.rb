class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.47.2.tar.gz"
  sha256 "b782062d3e185de065632d6cf9701bf9b4be3419f688cc9a996f7ea397fe2c9b"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2e65d5a8eef1430e50ef605ea351af421e81c1499c090e014056131f76b5f0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12f418080f38f842951cc49d044a576fe33069cd4ab49198242fd9250eb15390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66922d2489c66c9c173ab301069c4d1d96c06b1f9d652bd4a643e917cb1d84b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "944ee7d4954d8016b0bd6e4784c25596caa09e0548a368cb3bcc2c37c29e8811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aca4ce403427ecfb2c6a039647c454c18e0db242abbd7b781d895fc69fbc6a67"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
