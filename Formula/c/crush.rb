class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "89bc03dd7dc80883f76e1e6136e80b6d01af401461ea4c6cfaf35e4edc91e6a0"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d2ed4510b65498f2caaffb5faa3e4c45afed0071f71cf52bb14c550c3bddfea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e04d021050a249565fcb0187886cdea9155e1500b2f80a8b20773f081c91fb9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2840dee80281ee16b86a3abf451d7fa7ffa92ee37095bea79110a2dce0a6f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd1de9e04594ffb55cd5c29303ca15f4fa43539d58f89ec7e3cdb8926f73aa94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c43dac7cee84fdfb03428b81e4d97a721e72bf3484ddbbd07930222189c6389b"
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
