class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "c1f24b8334abc114f0ff4f08a59fa50a52972cd18c23b7eddd1eaa4b044ea390"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239b051bcdf999cef651fc47d3a37d824456e75ba187a197398e2a5db6980e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "452667d4f5996debf7e4075e802105b1742de2822a60185fa72a63211ebdd586"
    sha256 cellar: :any_skip_relocation, ventura:       "7b6f9e2826d37e4db0bf252d3f6a555bf981a41beb3b8fc27d4dbb8671ef39f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3b2d48ea84d655376e5589809868e66fe0859cdc16c1935c46ee34196e3274"
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
