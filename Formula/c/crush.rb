class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "376d67603e786c01c0c22a543313fb50d6862a846c310ff9ee05d7eb3b4d3a63"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02acc6616e6c3d7dc5a7209f15af371fe493ad0982ec1a0f8c9802a270739c76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dfe809f7aed62bf868df85814b88167a7441918d0f3e357e271b08779636de2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65379d5a1d9d5343e07f5438a2bf46512d403541dc29a091c5ff871ec9aec87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2cacd5e1287e46621ce67d497fe731e88fb84bddd19f261737e616f928808e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68485a1ac9c10c256880de2ed35332b63c807b122c089709702c6ee2eecf6579"
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
