class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "b0742e565c6e05c0e59339bedf37d79ba22732dc62a533210f89892b040503e6"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0795b9f89177e7422cd2472418a2639720315821020ba3ef1be1f1e5b1d996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ade7d2bd81f66edb69909ee6dad0b3f21965fd796436cedfbc3bdd2ecdc9166a"
    sha256 cellar: :any_skip_relocation, ventura:       "f04bb0460333e2937d11abc5cc15f3c46ff49fd6729888664b9b026a58a1b193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f70cbbeca2f75df87db3dfa75dabe2eacced01839f6c383d9a789bd03f69678d"
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
