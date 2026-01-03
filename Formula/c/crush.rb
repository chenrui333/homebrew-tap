class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "680fa70a0f9dbfca938cd3e5f3af5189ddce7becfc5ac2890e3570e29656cd53"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ab82203d57004d11a05f71fb1a83638e3b37533c0573afb85918720a1e06328"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ab82203d57004d11a05f71fb1a83638e3b37533c0573afb85918720a1e06328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ab82203d57004d11a05f71fb1a83638e3b37533c0573afb85918720a1e06328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5a5e73d69995c7a156d7303d83b68afe9e838301b7d7eb126034f08505cf6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096f816dc453a138420162960fcaf295d9b3e162b2114f5edaf9f3d60b6a37b6"
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
