class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "3b79b3e1ccc7f8a6eb65a76920faf9c1b5dcbfea447081fb8f38b1c37cad7f92"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba6969264b91613254f9661b451d615c6aa56668014b495d19585b1a6a4c4bb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba6969264b91613254f9661b451d615c6aa56668014b495d19585b1a6a4c4bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6969264b91613254f9661b451d615c6aa56668014b495d19585b1a6a4c4bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9851fe6af993c97f5d4658af0b53c4994d14c68aff9058a1ab6b153c3c48a353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64f16894c0231737915ab79d80a73ac7c6be39a0ea42ec37d676b26a7befd32"
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
