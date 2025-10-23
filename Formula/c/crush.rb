class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "d62261b285fc3575ee7236f3b51f8df3c341e33208d4d838b315921d7d5edd51"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0359834f3797a5cb5e4b02bb70564165458e931a30d3245a2ea61f564923e75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0359834f3797a5cb5e4b02bb70564165458e931a30d3245a2ea61f564923e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0359834f3797a5cb5e4b02bb70564165458e931a30d3245a2ea61f564923e75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17f81c980f4ce967c345192f46011a7efa6fa48e27282e76bc3dd03011f151d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f81307aa14f77a5a554dd888768a30b71045f93f978d8e1185c975575c5a7947"
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
