class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "18cebd86bc06d010b3549ef7c6601c8728670c0202db55508871fd3ee82640f1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5f5b4078490a0cb568a80bfea0a63a542cbaa93e0be79ce4d004362e3da26b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2980c00eb7aef85c5848ad8fe8c8dd8000dd6dc646e003d3ec690a4422ce826b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20f3fec9376e1913e4e174d347b71990bf3bd9492d1cea6f474a3a05c49443b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d8386332fd569ae4c8b52e03c2bb1c6eafb60ed8c686bdcdbad744f6827391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82e83d7e1ab76fe98e3d47e9d05edfec33a333b0b61366c5f72ae1fd3839cfa8"
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
