class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "ba773fc0e1883c7cf4d1a6ed53d5d70ac1da80af59f4e8e6e043d3901463dcd6"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d27fc7eaa7294b7a21132c35290846499776f14bd3ebbf3db16032c3582b2502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d27fc7eaa7294b7a21132c35290846499776f14bd3ebbf3db16032c3582b2502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d27fc7eaa7294b7a21132c35290846499776f14bd3ebbf3db16032c3582b2502"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2abe85c73a8bd8a6a6befab17d2973be730b05b8268a4c78c6a1b1ceb6758b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175d0443b559cdb757b34703771f61d8c93262f1ebb045573005fe25b25e0deb"
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
