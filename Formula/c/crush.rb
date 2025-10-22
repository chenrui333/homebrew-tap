class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "cc090d61390b962e442b6289f8f549a67cf263cf14a86b2440f7a9db56938ac5"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1a17fdb23e7a5473f3686fc9d45cc58a7153f34ef8d271f232227567efb85d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a17fdb23e7a5473f3686fc9d45cc58a7153f34ef8d271f232227567efb85d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1a17fdb23e7a5473f3686fc9d45cc58a7153f34ef8d271f232227567efb85d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c75f2b43433179f915e369920212cccc01ac0284db52a5df19d44a49377f0929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c785b39e84933d2fdb197623bc6f739344efcf8cdfb45ccff876c5cf2c838174"
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
