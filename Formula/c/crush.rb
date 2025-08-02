class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "99efed7442d7f246a215646628bff66238e45907083c54581e775d7c8164ab93"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dafd48e0d5a267f92378ef5ea2b985f6c983affbc2db4c56a3d8cb07cabb8aae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49410f71c25d0e04ed1a6a5c09af3cc15c8a4a0c26ac9fe49a273c86e7e73a60"
    sha256 cellar: :any_skip_relocation, ventura:       "65f07ecd6b533f6b7a7229e8165579d7111fe7eeabd715a2278e219e3e1af412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7421d79bafdbcdb40d1bbaa3abadf67f93ab976522c73a5634d0b3218632d291"
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
