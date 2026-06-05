class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "4a1a7e2a5675ee6f1fb26c2c5d5307d60b6fecd8d5a9989122af0f3589b1d3bb"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b1815c8b74552a61f5bebd7ea71fe9ba1a81d15832bb6d8ee6057a908ef494d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d91ffa8e6e724183dec0bd125a450996083dc612e4692a804495266b82240270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc76f181bc0ab923ab396a317a0c6776916929e903d26a97d50f56a7874b0344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dfa31e0f82afe054cec6e2fcc3c4ecb6377bdbca2f885e10b4d1158e54a9ddb"
    sha256 cellar: :any,                 x86_64_linux:  "ff0878f1f37f08fcaeb7d8bb99a1ad1ba19b98fb99cefa41a742868f812778a2"
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
