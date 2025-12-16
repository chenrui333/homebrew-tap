class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "f1679690bfc3de42983b3653c0c2bd471036af75a7636e228549ed38e22bceea"
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
