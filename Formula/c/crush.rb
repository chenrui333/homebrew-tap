class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "b55879182d9dcf4a6d6abb443604e77cf7bb99917b94c5a672998348b385d350"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e598974190d5e83f4c6c13b5dec9932fa3850c51275319f82c6cb8c9deb51f4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86363935a657f07d5faf0b623b1d90a3a97e338dad0a94d658a4bdcb88fcec89"
    sha256 cellar: :any_skip_relocation, ventura:       "ea133b31f33613c2e0f4d64ae6a5dc6dff7205d52d2d618973aa7508305c0296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9541219a8a8e50ed64734283400c0cbe3e9d689640fbb8f49f511cf3d5902fce"
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
