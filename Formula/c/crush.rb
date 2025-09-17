class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "aa6dc99568dd0af52d42e5696ad0110520bd9b4a4916017246ffa2233140ae6f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "645040e862fb0df0ded7f05bd912cd491592c28badb9c7c2f0db0feac74bee98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31f4f857934f3fd33f504628e3afe2e8ab69c015f04a2bf29eae207ed7a0157f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e66e71d4cd9e96c3dd2dc158d2d15e2a406def0d96bb3c10f10906ee5a2dd7"
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
