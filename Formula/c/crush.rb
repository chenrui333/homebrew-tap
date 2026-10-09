class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.98.1.tar.gz"
  sha256 "fcc671cc2615bd9c3bb2ccb8cd74e9dc5f4e5b4990ddd4e041923e5960eebca4"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "653bd7ca96d4df70640289d591cc214eb3eaa9bb193783b59ee7c0ac3c4dad39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eac3c06b9871eb21e5cb8f02a350aa321803ee9fb9db54db055e9cb79a6477ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfefbde531cef05e264bfa41d28f021342f618075291d1ba2d6f1b9bdfccb2b8"
    sha256 cellar: :any,                 x86_64_linux:  "4d146aa0ca011d180b8b83e5dadcc2dbc5c4e357bc31ea69f244afc6ef0f55f0"
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
