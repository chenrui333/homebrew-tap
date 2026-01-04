class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "7e4fa416533bb9ba285d03348c373bf05e6ac5c0ed81c13321c0f30d6f680ad5"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae243c7294137407c2d8430cc1921841604c730855856ca41e0e86e0d19f2c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae243c7294137407c2d8430cc1921841604c730855856ca41e0e86e0d19f2c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae243c7294137407c2d8430cc1921841604c730855856ca41e0e86e0d19f2c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afac216bf1867e226a6706039a2a8c01fee9c5df70422ba738e871f8fd1d4bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a39f253b8bc8a98ffa58be193b0882634e5c1e61139d1a72bec4533ec270f2d5"
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
