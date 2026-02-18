class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "3a1b3eafc95c44bd9273d1e00f5e957e8b2968acb2b4e8a803aec5fc26abe939"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0966e42e417438cb901f5701b6982dd6c7c5c74704699362398bb26cbd4bee1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd6b936d25a89d5b2968cc6ce0914300495c4d498dcb7d50bf36199ba760bc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09979c685853f460ac3353400d4ba1b29de097679de46a5854d7fd383029b1ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "116727d8dcb5e32d23146597c496f80cba08425888ba106ac246cb067150a86a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c3fbdb696270b439924e2bb1586391d305165fa43d3abb86ca7e174ba381cdd"
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
