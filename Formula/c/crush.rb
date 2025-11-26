class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "8fdd7787481c0ea097239933f8c2dd7e67b1b5712210876678b8b318f12214e1"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2fb565ecc712408c4a9aa159d1621bc2f0b0033b1ec7602139cf092bf5ef7a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2fb565ecc712408c4a9aa159d1621bc2f0b0033b1ec7602139cf092bf5ef7a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2fb565ecc712408c4a9aa159d1621bc2f0b0033b1ec7602139cf092bf5ef7a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d1f5c1bd43a623d71c97ffd111d8a58190e41d043f9a76268cc94f17517fec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00887e0583e9e98d3411023a7c3189788dd2540ac497de34e112c1b6f475503c"
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
