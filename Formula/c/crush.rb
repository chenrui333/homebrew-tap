class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "7460b8778f83eaa116c0724ced7aff20378fc6c5bb9fcc2c1f0353ce544e41c0"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fcb97093f61fbb2cb711ab2e95404c2fc5f0bf60a2e0754aa9f5f4c82267f16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fcb97093f61fbb2cb711ab2e95404c2fc5f0bf60a2e0754aa9f5f4c82267f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fcb97093f61fbb2cb711ab2e95404c2fc5f0bf60a2e0754aa9f5f4c82267f16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7101c7b3f8259bda8bf754c1653d075a19ef5bc9a6c9bbe2561fb12710486ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "174b17a683e1ddc9d725656632199fb30dd635437ae2117931279a08789fab57"
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
