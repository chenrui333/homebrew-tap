class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "3fbfbbab71ac9212efa7ce5cac8e423e54cf7ac1ec6f6de4f69291f0341a2d9c"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ead537f28ffafd18cde8c4d4dabf3783612e4685b1c58562d30cdd5b6b0f867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ead537f28ffafd18cde8c4d4dabf3783612e4685b1c58562d30cdd5b6b0f867"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ead537f28ffafd18cde8c4d4dabf3783612e4685b1c58562d30cdd5b6b0f867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0aefc86f40f2e83c0b8e39e60ca1ee471daeb0066afec4e19110ffdf0d8f555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68b456768bc746eb79172c161440ead5b8f4581e7ad712625e19e2221761618"
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
