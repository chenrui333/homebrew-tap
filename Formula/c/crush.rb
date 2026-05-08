class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.66.1.tar.gz"
  sha256 "afd4dfd58001f955ca429bdb8eea1329705d188d924a80c7a884bb9169efe089"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85caecb6859bde224cf6fb2b184e9c7dfdc15e03a6478d7eb9497578be47fb36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1895a8694083addccfe022a28dda6442fe24238738601bbbe43f277bdd331da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c33b70c18212483d6bd342cd68ded62351ad5607123281568da04a10bdab9183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9097555c4d57bed34d5dda458bed2b96b0a27dadcc4b2ed6f65b79627a075ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46dbf56e939df51b1c5c451f2ac5a45ce963db56fc1a2cb1da7155a1b70d3009"
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
