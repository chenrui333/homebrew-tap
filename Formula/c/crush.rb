class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1aba76136ff152989fc899effb5e62d259a39a4f981db7ca7d57b6adc94322d1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab9b019a1c2fe6033982b8524e011a9e5715bf6de329ce0ba92188dd03436f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e27325025946d5296621ee43c36726e8d2c8b562b037275fb8fc7259544cfdd"
    sha256 cellar: :any_skip_relocation, ventura:       "b69bdfbade2e20bca8d32798f52f202cf9ee4d3b007db18416c49cbb722a1c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cba84e3fa309f90369bd4f919bfee379b78057fdba84c3d14dfb7893c55f87e"
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
