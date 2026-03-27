class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "d7017677fbb3e59be745353795e219bd73c9228ca4231f73a73cef303004004b"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66a2a01ba91608e25759d6abc6261972e7a7da73ff65e7b9e3853d3f4a9af439"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d049fe90d44bb195a882e315f865804fb2d7376b6f9466b2d1a1d687de721358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ffbb33d2fd6ae30200ad31a64825c808275e65410dbbd2af427eb3c7ddc28b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4adc85352d876202633bcb7a39c01206c560ffb20c2cec2fb8e7f791dc2bcfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34ef666cbd1d8a04439f0528ff0ff0f231e68a8a3caf2791f0f52926a1468544"
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
