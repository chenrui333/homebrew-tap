class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "aada045da32286af547d55e9fb28a0c7d56c0d8357f936a47f1079caeeb97442"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dcf7a6ce59f32517e967537f22a8bcdf215197a676997f57f9db3928a9d8025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20f5d43a6c426338a82c4cbb2cd7c21d045b13f538b032b64a48c55a99b6b17"
    sha256 cellar: :any_skip_relocation, ventura:       "58bb28f17fb10b72265479e1c109c51e473c5b9fb02d76cfa00b2b87b2237637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed807dd2a40f20faebe4a2d1860fc8fe165c3371aeffa4140c956c13dc7128c"
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
