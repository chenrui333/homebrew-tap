class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "1299daf7c6d4e300f910f68a21277cc30451bdf4dba584ec87a57b84b2ba6933"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be12ee5b81fc3e806d5fb1d2bfca9a0e6200efd9c1afdd9adb05c1a6335676a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be12ee5b81fc3e806d5fb1d2bfca9a0e6200efd9c1afdd9adb05c1a6335676a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be12ee5b81fc3e806d5fb1d2bfca9a0e6200efd9c1afdd9adb05c1a6335676a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8fae832ad6f8749aa711005ee3c9d9fc5802efcbbf65e52d91856494f6b94c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bb516f71282c8ae5fd86af47dae089b3589a7dc4ab239702019ffb228762422"
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
