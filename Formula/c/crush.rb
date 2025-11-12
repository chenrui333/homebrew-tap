class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "05d65ebb3d14355d8fe57252f8e3e4eb27cc9421721c6bb4236fd28cbdc8eb3b"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44cb5f993b48a1cf73552e007f87ae71d5af82fcd916e226543f46be9c173ffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44cb5f993b48a1cf73552e007f87ae71d5af82fcd916e226543f46be9c173ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44cb5f993b48a1cf73552e007f87ae71d5af82fcd916e226543f46be9c173ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d559fc16a806030f0f691200a9de073c0fd3d9b0262cba1b1c735c504357de87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062c0515c70ceeea5009ba0ffeda168055d8ed486fe254d3f995685d4e30645c"
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
