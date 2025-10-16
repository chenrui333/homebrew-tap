class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "a75e4b7dde223f74498cb97f39d1bae2a88415cc346e0ed6c381e82c9350bf08"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da62cff4df27ddbdfe06d4c125dfa3f4871045cda2fc6f3f62fc45ca277af957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da62cff4df27ddbdfe06d4c125dfa3f4871045cda2fc6f3f62fc45ca277af957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da62cff4df27ddbdfe06d4c125dfa3f4871045cda2fc6f3f62fc45ca277af957"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83095f77bfe0faaa809211b83707aca63151098f8b98936fe64e11134ca02b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "677ab33728bd7a02b57ccad22dabfda5f78f2c68e96861d1169a7bc6e3288bc0"
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
