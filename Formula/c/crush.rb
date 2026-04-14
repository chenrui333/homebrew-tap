class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "0ac66bb3df675cb21e9b3d95303d6170e034faf3fc998bb9ac167af8f4409e95"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff3b2f5958743dd97d91a51e1c86314bc78851fa75cb930b215e647152544ab1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "852b3e913298e1f83958d0ba6bdd1966a7ec406807a56f8ed3dd2f25212c66d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ccf3f88f97a83ab781cf696c3b6ccbdb3be061edcf93795262c448a2e031e69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "323472f4a3a96964a0360d214f0de14564fd041dae9ccb355b16feb445c67d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5765fef3d22c0b3f9af6c5e2a26ccf7ec2e11e68433b1c1a7ba1223f56b589db"
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
