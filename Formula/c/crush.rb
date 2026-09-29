class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.97.1.tar.gz"
  sha256 "2d008a034c3e7351937e69f4b21ac653e4e0ae2e1fb0fe11b8d37a3094c15d9e"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95431be2b8b068acaa2c062063d19de1fb0a907a48102b14c02769cdd864b09e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad43bbb7820913c4edee808545b16bc46266bd0ce7f5e0425cc6404de6961e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bb3b58055b1ad00e6def6cbf64f779d1dfdab61dbeabc1e7dd0f50a80a2b153"
    sha256 cellar: :any,                 x86_64_linux:  "7fe1906c33c2a33ee1ad4cef828416a02c133a71cac5622ca9627ccdd759f928"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
