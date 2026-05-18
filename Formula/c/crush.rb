class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "fc60329c04fd2822f08467336b74a0c73c4284cdd242a3808b11da7193363a39"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aec58b91c3bc17dc2a6cccd4834693e1e6449769a3c6226405a4179ffb0dcf84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "795dd48bea5634b6dae3144063d3e672cb9a10b4242fae727514e5ac392e66bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f0f2192d8199dd4d83a23aecd213cf593b42970a0783769259ca9068a3ee3cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0d4502af36a3d88ddc30552e0797f92f93935eff2fe378297e0aafc8164c4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a99e084cd5d3bf6286073c7aadc22da2a27f505ba4ee4635a1a852ea0f6429a9"
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
