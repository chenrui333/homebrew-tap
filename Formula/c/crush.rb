class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "99efed7442d7f246a215646628bff66238e45907083c54581e775d7c8164ab93"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39cbbdd9ca0add7dcab53a425e20209a5c0649173e97fade1ab171a35c9885ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "312cdbeb90f45e5d3ff182fb360d09fbd91f934057025f29dd9112f1da51e480"
    sha256 cellar: :any_skip_relocation, ventura:       "1f6f16c89519671cf2b5e38b3996e79c2aab9537db5e10f50799f85af049dfee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d4aea6e5dd797f341aa2342ac5b69415ff55f8902aa0c03f17930a7b51bea4a"
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
