class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.79.1.tar.gz"
  sha256 "84988460d9f7acbe9e22341f34d272efbe07d05d4941f1e00c085270dca920fe"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8574f21d2599ecb12f0b6ea5e446afcc36287fc5db59068aa9f4f22b019e023b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddc3e50e4b43b4e7494475522c847432f6f9df4be21cbba82f7b3b813ad1eea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74a1fc13092ccec43ab136b3b841de0c57b4e9ca3a2d583a15ec1767a5bd9894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e9c45a6fe083375a396b123a965fecd81ae6525e47442509112431d69cc12d0"
    sha256 cellar: :any,                 x86_64_linux:  "31d6338acafeb9c8cb60c2f1da93037141ac9f897be2d02244758fb3923230e9"
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
