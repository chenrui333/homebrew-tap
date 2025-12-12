class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "deb4fc776e14ff8ab6728305ba3cac91981297567178ba8fec1a883cc0af6fbb"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e821cc3e22f10190a249be17d2403b4ba109ceb395a76ef497585b58a2ccceff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e821cc3e22f10190a249be17d2403b4ba109ceb395a76ef497585b58a2ccceff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e821cc3e22f10190a249be17d2403b4ba109ceb395a76ef497585b58a2ccceff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1f82c96eadee0ab405712139c8c1443914cacbbeb4d5f16f0f2a10a0ce68939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d519143b6d1dd8da59016ccf273227c16017a1181f00aaa454dbd18109544124"
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
    assert_match "No providers configured", output
  end
end
