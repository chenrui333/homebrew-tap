class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "b679c5c845d6f59ffe60cf1f7eca75a276f716be662e864cf7c5537f1b614803"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6409050879bb8d902652853241c008c7b5b54c2498860114bfbae160590b4b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7f01677476751894973db183b564a0c038bc57364be083743e13f2c3abcf2ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed68fe6c7d948fe0f8f6ce8c6412168b337c4b00afd29ce6277992839573b7a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b1b7ce49c58f7e78929feff8b2111a76b81b7bcbf1b5e8e75de152d1538813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9de492c6e3b3a936aea25b14fd5ce5386eb7bbcbe25223525202e8a7706a20f"
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
