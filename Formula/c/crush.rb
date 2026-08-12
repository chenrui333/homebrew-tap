class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.89.0.tar.gz"
  sha256 "b0a2e9abd48d70d26dbcfc1aa8b810de104991e9bfa80252968c2fa4fc6463a5"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "500bd8b30d6537af91b853b2c494d924861acc57fed742c20bd453a31216a14f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aaf7a2c7159278ca78dbe2e3f97c72d74fb34ada56e81ece817b94227d4c624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0b85ac50a043e3c3634498c671ec6e2e36ba83d30eacf01b33aa345a3f0966a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07503d3062bb7aaabd3c7f08d7b82da1e002edf0f8ca16b03f6f2bbc8627d44f"
    sha256 cellar: :any,                 x86_64_linux:  "301539e3942771e8fb7144062b553153add0dd41077b9f80848e6a8f8dbf3f7d"
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
