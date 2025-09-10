class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "0d5149bfd0f5290f83cee5c0dccdb57cce7f2b3bf226ecd3b55a251e5ecfb658"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58075b828961e222299e6863c12d79f51b992264a020c0c2c4b2a7c181667448"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13b659a79c9ef89da504af4baa588529e242336aabe3796916ca996e9a868f71"
    sha256 cellar: :any_skip_relocation, ventura:       "38021f2d5d1bf82e2202cced1c330018dc75fe93f29236efa0b38eaf6283f6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad7904724856385f97fcc5806b5fa96ed635dd5efbb442043c4cd234e1038e24"
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
