class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "a12faaf5b2c870faa1eaafb73af116473873cc8e05eaf720ff0631098b592b82"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08890e97c8bbbfee42e440b3ff0b9b83edf5b1c04b1d1e221d4d832e9a899f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08890e97c8bbbfee42e440b3ff0b9b83edf5b1c04b1d1e221d4d832e9a899f95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08890e97c8bbbfee42e440b3ff0b9b83edf5b1c04b1d1e221d4d832e9a899f95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a53425afe921fb3093fae13ad903563fcc5e39f4a2761a9aa79b6f1718dd21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa5455cc7e51d1a65d2f5eba12bb88118b9c21fb4d938f6bfbdd85a4cc6bea1"
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
