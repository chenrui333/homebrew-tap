class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "5cd271ecfe9bb567c4513966e187cc784054e7e36126135c7b677f124412ff8a"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b5aaec507cf95475a787c4a31afbb22ec2da7c51c328711929776ce029a7a8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5aaec507cf95475a787c4a31afbb22ec2da7c51c328711929776ce029a7a8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5aaec507cf95475a787c4a31afbb22ec2da7c51c328711929776ce029a7a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77aa8354ca9e2adabf22cdf0bfda69a4ad4d2bd00a8d2800a4048640b555e7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4916a1e2b34df67a657e62785c32a69e149c8ee6dd0d378c6bebff6802c9d715"
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
