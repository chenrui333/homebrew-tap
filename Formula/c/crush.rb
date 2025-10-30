class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "03e21307b41fcc9ed79ce4a11519e09e091ae209679f9524dff30fba463a1a6f"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85aea41dc80808d323f7cfc73ca09095bfa061f28c78642defbfaed465ad07d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85aea41dc80808d323f7cfc73ca09095bfa061f28c78642defbfaed465ad07d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85aea41dc80808d323f7cfc73ca09095bfa061f28c78642defbfaed465ad07d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "061270009d071a0ee053da39513d20850324f972acdd87b79baba503ef73ac85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038c066c1314a023487ab8a0249954072a08662bc3515fa1d0dcbedd561f9824"
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
