class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "e977632e0193c4b270f87b909a79419749a22c9603604c9c434f2a6f16ae35d1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6d1c56a44ca9db85578f40cc3c676d36b3890ea5d65d0e285c1b252c04705e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1707bc3fa1ded19fd9c452b8cf566750b6cf2ad70b46a65ecf3a076185b861c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ce21d72b000caaa9f807416630fe8969d1abe7959115eb54fd1a5ce99f946ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3eb1e51700cf89c5fc44b2ffe7b460e0a45272b4433a89b6a7a769d4500bcfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00bcdfc10966fd908147bb762cc0fdf88a7067b6b3dd676648cab21b15637899"
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
