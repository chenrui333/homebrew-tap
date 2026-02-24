class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "b679c5c845d6f59ffe60cf1f7eca75a276f716be662e864cf7c5537f1b614803"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e6cfe891dd1ccc35a29ba630a3e74162bd275532f1da9adf0cd137f398abb31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6961757d18bdcb3393b94a1b7040f93bd3aa546c69ab77ff591dba49e0b47973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a10894843ae9e485a1cac118585e535e195524dddbca08157aa0197a4aed22c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81d4ec44bb21a0f2bfabc62b17d5c131f069a78ae5ee0f68f43602cd262b838c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d6124087aa1a6e966e7698447ef884a7dd518ec24d05ba72da3748e5ff2e2e"
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
