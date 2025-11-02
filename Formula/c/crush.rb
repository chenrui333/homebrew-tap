class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.13.7.tar.gz"
  sha256 "eceac81d991dfb7d3929668b5cccc559dccfd68c6d1ae9726da301b3318d08d1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86a4c79c3bf743429930c311aa093cb07e58a4f0c8c13b132c876cfd27e7d55a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a4c79c3bf743429930c311aa093cb07e58a4f0c8c13b132c876cfd27e7d55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86a4c79c3bf743429930c311aa093cb07e58a4f0c8c13b132c876cfd27e7d55a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25aed1725766a41f9d1318e6d4f0bfb62fd87ec9cde93040f0c7d67873bba953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae272f60d11bf18fd1d17dbf3240212b9edfbea2b94ed91dd538e2905d4bd12"
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
