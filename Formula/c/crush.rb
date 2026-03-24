class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.51.3.tar.gz"
  sha256 "63f81d3e0683ef0ea8edd91410bf61bbb8beedfe7b4bc9fc84f1e1296aa4b8d1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0321e61bc77ac6cb0c6df24f0f9517d637f25b39e7e0594c8420f9ae0d826512"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c7ff27cf61ede91024a097b72c685e06d36744af6ac0931392c51e389105473"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f99b8882ccc97f22145d376dcf1484ce5f1ad4bd69ca1feed93501d3d6bd88c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0b4d8650a55e2d445808e059ac2d3a0f5fef238d69ca2ecd5ee51792359391c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29d52cb9e9e7bbe3f881264761eb9cf33e1c9ec051f6d45820daf40935b82d39"
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
