class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "8aadf71a18ec33cf09c96d7371dac3fdeeda4364caa95139a4bf1a78424cb3ff"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a09115420113fc2d77af9c4d7ff7308b5d2c67fe5c682c276098df246d44bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d43f4872f719d0841d859336aa1b82a1a533667041baee0a6e4e7f123d31c2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db832f3fbb48573c20d8d0803b52e522ff6be62cf8998157549db5600bead66a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef05c9d9ec8622dcbdd4458b13f7aba8a934247580b576f8bc3a9f5cc6bfdca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40913a3aaefb0ee17cc6537d996d7d2b69ca91ced320dc7ec46f2a782dabb481"
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
