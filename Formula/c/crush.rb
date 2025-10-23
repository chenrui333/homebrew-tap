class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "d62261b285fc3575ee7236f3b51f8df3c341e33208d4d838b315921d7d5edd51"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "575c7adefc4c5f74667e7bc88dcf57541c4c7d1c36321a4845edb4fab3c3efb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "575c7adefc4c5f74667e7bc88dcf57541c4c7d1c36321a4845edb4fab3c3efb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "575c7adefc4c5f74667e7bc88dcf57541c4c7d1c36321a4845edb4fab3c3efb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be4d5fe97e70505b50de03c0f96097ff1d139f42b139c8adfff0c2911b931bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660e74dab8cb48e748e754b6717978ef78b9cc4cb35e3781371ab05116377ca0"
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
