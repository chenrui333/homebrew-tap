class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "45de4d00032381a178b33bc1b9adf0cc87bb6d31632d0d26abca84ea99926496"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "088273a6f673f982987b02606d9e5cba06c6555c3ab239ba24e2ff12353103e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15fde6ad8f82f44fca499612d0b79790cfebd0480a520da28677e552ef7b212b"
    sha256 cellar: :any_skip_relocation, ventura:       "5bf9aefecf5ad5bfe14c09d0ad7c73cf4362300c859ae471c0a482e8239adfc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c949c18a604ca86098d6074d8b385e8b08ad06c9b0c9a3ffcba4e89489af4f3"
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
