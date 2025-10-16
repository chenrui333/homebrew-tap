class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "a75e4b7dde223f74498cb97f39d1bae2a88415cc346e0ed6c381e82c9350bf08"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c4c149686f1e70d51f88785927fb6e02acac1582d9c04f348012d94ec95358e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4c149686f1e70d51f88785927fb6e02acac1582d9c04f348012d94ec95358e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c4c149686f1e70d51f88785927fb6e02acac1582d9c04f348012d94ec95358e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed3e765968a460e177f081706207c99a764b14b9180830ed343e4341add5af3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05f684c2426a7551e173c44d3e9a954417e5a2a8e6f909609b2aa48217d528e3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
