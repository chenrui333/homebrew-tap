class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "0fd9e301c61f6e597eed0dfe0cedb8abe98e763e8d26ea566ecfe31547d02451"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43a46c33e8c19d0b271dff1c67240b842db2353739a6e816b9e4ae8345368da2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8fe30888cc8e492c78e4eff982c56d75b473e5f9cc8e59023fc35160f0d1fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "004584175a2b6fdc96e9c8b72849328503ee77c7c0ef915617ae3c093cc4c546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06e562e66e4eb00362460179853ce9369b0fd591a4ae10739ff6a0b83e218e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5c62468cfad0d942c04b5770755d01759a378d71c57b04015942f45472ab01c"
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
