class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "0aeb405d820881a936f878b4c1a88f0782a7157c5df4ed04523e4061e73d1e24"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfacc4d7461140933d690c8bf4d26aa08f33305b8e79e95ab0c3e47a5a25b8a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94b5bf3fcf920b2533b1b89aee7a6ace253f87378476c8e8b4b5fd1063eb40c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d125a15a81ea329e44e03daa760424c8b11870d544a22a66f6df964bff3b93b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e5710a4eba623b178a7578e655bc5225d1bb8a75504b547d3f0061499d9c050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fea8ff3e9a0b3e8b7dd274729886fc85ea155c7778cbfce1af64ce57eb74e0a8"
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
