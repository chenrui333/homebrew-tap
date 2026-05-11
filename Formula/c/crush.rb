class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "08e0bc8ea910056b878937b171fcbac928e89db127667efaa7b4900f16542690"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "543e46dd9d2000e021e43824c419e159f1f34734ca6f00adbccaa1827f821286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d09a4e2740208648e0d839384a5af9a42ce052032556555008d34888536b927e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b618984dd7d241f23af9657306072c5ed0abb658555fc50bfdf3c594acbfa9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81e11a480215971b87ab0731a31cd6f81ca44ddef8d5a551f962aa2950c8985a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95f82109b115508d22fb0f1c85fd837f3fefac071fac342fe897072b517f2046"
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
