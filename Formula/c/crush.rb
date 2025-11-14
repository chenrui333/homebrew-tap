class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "ba773fc0e1883c7cf4d1a6ed53d5d70ac1da80af59f4e8e6e043d3901463dcd6"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c61b03bb140edbea09481a9941d69cb7d6570eb246a2bb017658f1998292bed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c61b03bb140edbea09481a9941d69cb7d6570eb246a2bb017658f1998292bed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c61b03bb140edbea09481a9941d69cb7d6570eb246a2bb017658f1998292bed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85282e697337f6299e71607607fd4fcb1e23d5bf1fcdb20c5fc8b2f7877c15ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d84cce472c705ef7269c97b84720b355a17460c73740e1293c12794fa02681a9"
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
