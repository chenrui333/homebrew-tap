class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.43.4.tar.gz"
  sha256 "22ad2171b6d27b92d2b1189607632441194c45dd51caead655114ed2d5a731e0"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e420bec6fffa8223e93d95b597ad7365db85c6ecab0a2477ee1460c3fe1ce16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9620609656985b8d2f2fb087f6fd4adc46aa89066ad804034a6d1a0d0b299a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50450ce090bfe1798b219bbc196a6b80f9f7dbb0c96a8a8d72590fa277217f4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654f04787213f802423c543f43e97aa97cd2d8666ddd10b343352ae50a6f989c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa7f7777887978af385f125d931cd7597e2d77edf2d3c55b32db895ef6554f3"
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
