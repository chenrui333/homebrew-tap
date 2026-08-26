class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.91.2.tar.gz"
  sha256 "fe6a73a6e512441fa3d6dfaf5473cb3348a71965e904cb47245faeccb74520e0"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3e52a4b0787a886d24205478c9df3a88889fc8bb6b260897ef311cfb72288c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46e11c28f36941656821b87120ce5bf73496b0744081445f223bd443bb8aa88b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dba2c187b53fb5e12ba2b6db27b254e9660128c9165b853a3d2eff864836b47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e508b1e6b6f0be0739a9fdffa6ef450ccf322b958d674decd61cc04a13bab783"
    sha256 cellar: :any,                 x86_64_linux:  "56e45b8e35d9c1983a2dc8dc5efd8f4051cf8eb67f9af1dc94367cab5b60c31f"
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
