class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.51.2.tar.gz"
  sha256 "619e09e7c5e4b9351de642a2aa9ce6c91831b607892f5ed8d1c072998037639a"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aab190955c15d483051d387fdbfb931278b07021f0795d76e51ce08d2bc57eb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bc78d54ada0e4eb23b81fb850b87f45232508eaa84780ea0212698021dccf49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fb50bbf59aff56a43941f13714d18f44ed27f6ab5eb376d4194a5f33904a421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86a4d50e7950967f688f7584fb7d34f156945d6f94a5846179ac6b153a2625b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dd04ce4732a5b44d7ea187842829917ce2a762ea665d49ca563f0393e00d286"
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
