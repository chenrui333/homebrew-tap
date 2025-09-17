class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "aa6dc99568dd0af52d42e5696ad0110520bd9b4a4916017246ffa2233140ae6f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78428eb58955bd03ede222964809755d45169adfb69f330c10112f3a024f6084"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d253bfb791faf85e3b7ef5176a34d759a73bf451c5867d04e259d929b9958845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e30628228f2a55879a60ae282ee7de29ddb0f1ce38fa49c6e263f9cfb6cf191d"
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
