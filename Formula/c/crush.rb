class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "cb899bd362a69ae169ae4506fbe7c0546895c2ad937b647767ef0bb98adcc346"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86274db7f46703e338508ba44acd48e0815c74f7eadaa196e457ea6e146872c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86274db7f46703e338508ba44acd48e0815c74f7eadaa196e457ea6e146872c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86274db7f46703e338508ba44acd48e0815c74f7eadaa196e457ea6e146872c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ffa06ee3b75b4de823c6a912a0d4636953dd4c53c75293d21c1b279deae098f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c66bb5f87c36803ee265aea14fd14c8e0edb322f886ab8264da7f042dade445"
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
