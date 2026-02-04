class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "6067877ca26ac138ab33e8c33303a76645e1c0c9afbd659382fd4c30d877ae20"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e75b004f107b7b999b26c433c363b41609374805197488658450c33a7169ce62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15c46971590b19eddc77cc7c4efc8978f90d6607d3eb765904dc8997ca9a5b39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "901245af2e9339582d00b5bb50bc252c3a302fb8b6d7862ebe812ce73fedf362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cdd041e6d5a352470ba4c3a5772ae0ae36362846d34b80de5ff7660bbfc6df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8138d65aa0299cf00a254d9860a16ea894c1173fe02f5f8cc74b0af1716fd093"
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
