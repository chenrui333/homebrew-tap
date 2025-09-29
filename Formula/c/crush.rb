class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "514b6e4b3bf4e43e8494ed982d9a863dbee270e1b73ed9a997471b417c5ca345"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391ef7c4138115f45fd50068b9e5d4819bff9521ca4062f98a7c04b4b45c513d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b1004d1fd2f18d801ec893a18a41ac686b41c3a291c3a0cb60e49a5a8824841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0560cb3c759caa5a37e4b9c4285f690acd39bcd8449a9fa1516309158d33ac46"
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
    assert_match "no providers configured", output
  end
end
