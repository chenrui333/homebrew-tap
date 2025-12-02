class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "b654bb09ca5cd662aae176ee22bf63db3ce879b5158031f0e52d2f2f16112ebb"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e521aac91a342497ad2b3b6954e7a59e58913ed1091f892c1d76a040bdaab6cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e521aac91a342497ad2b3b6954e7a59e58913ed1091f892c1d76a040bdaab6cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e521aac91a342497ad2b3b6954e7a59e58913ed1091f892c1d76a040bdaab6cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f80713705182d6cb6025ccd342cf59f575d34c3275b81df48c339096f2a5bd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65711249306f18ec713de742e4ea00966870da1d0f8aa5ac013771626fce16a1"
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
