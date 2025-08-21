class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a42ed71c75b697b1e972d1e0a7c42b2ea3afe4bb2f296b1a6c4a444ab54d7e45"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5abab2f849f9cc66c31c4a2a1c72322cf1017abba286185b4ca2605edf0784ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "834a22877501742684a56fd0fba4d2854d009ec0eda260d33e920fe09f273a95"
    sha256 cellar: :any_skip_relocation, ventura:       "9521d3c2875b501214fd09507e2dfdf3feab60d412d071c12d205949694c66fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3744849f5ed14a1e572cf8490a451bf9568b547b83cf537fb9b48070b6ce1f62"
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
    assert_match "no providers configured", output
  end
end
