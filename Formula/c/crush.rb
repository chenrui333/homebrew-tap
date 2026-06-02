class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "edf374615216ff8fcc1ce0046b57ce2a87cfad44c45a5cc1f5df4ae7032e201f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d30bcf7656d1d08bfc2827751d85e3ff626536a192fb0669498d6270f876200"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cca13d02f9a39aa1890c40cfa3c7a776c404504885600fade4ad5ce4e5f749d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f80009ca3af8560d878c2fb61e703a9d954887e9c17b200e596e7ee35f6b1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77430112b3f9c5d9b9124a762c7a034b0f5cfa9bab87ad80c6878d04f68642a8"
    sha256 cellar: :any,                 x86_64_linux:  "00dbda73be350f0aff2b9c0382398bb992d2e8c7f82b482e4fed70e557927cf7"
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
