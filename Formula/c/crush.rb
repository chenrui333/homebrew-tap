class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "1c0f89af2fcb84d5403fdc754f5070bdf308621b6b4ea56670d0bd02e25a8e0d"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bfba8605748cbe97840c0ada093684eb8d2c04104cda71eb1ea5bc4306d3639"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b153306de70142f99a40552a55773a1cee80a4cd7de1a97861acb756553e3ba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c238a7d53d5ec661736ffc7967b2770c0be62821a193b6fd7ccc84c95a156a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64f3706e87fd58d719c960ad4da13650e132588c96e1962c8f74767af2f5bd89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc675da3be239b6f6e8a9f6d5313a1523969933afd66679dba8a2a8fad0d17cd"
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
