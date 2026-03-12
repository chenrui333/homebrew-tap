class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "388d0cdb94708009a348b47c691735f2cb73f013fe2cc0a745450916785ca4d6"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "397e7908964d016ec4412902c5327abaccc46fc7b408bb29c71af3a9251ef8d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a3c753f1ea69c7560a23602ee2a51bd16ef00b41431f8eb9d5d5244766ff336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df6115233c3f2d1b3592cf81ef5f4e0b93be2eaef16c1bc1a90b633f07b2a062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d67a23172a91e814223aba0d9f94d38fb8b2b1ff4127fa1a27e3a71478825083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f9666ea3caf2f76c29447f309177fa68d24e2b7a8a64788118c450f8ac4c21"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
