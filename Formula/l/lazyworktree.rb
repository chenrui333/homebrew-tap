class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.50.1.tar.gz"
  sha256 "51fcb3b6e215a869fbb8e25b4ba40666fb2e15552e45f890511e173c9b6107ec"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00b460a360cebf822c48ff0adf1acef23b92e25a0f928d5771074c17bea3d5a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00b460a360cebf822c48ff0adf1acef23b92e25a0f928d5771074c17bea3d5a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ca1a5fff9af6b61a0e7e82a72c494cdf4a6cc0def012afbcb022c0450d06b5"
    sha256 cellar: :any,                 x86_64_linux:  "73f1bcc69746ddc17eb24c8eb8103865859ddf8ae191437f0f5645876464c574"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=homebrew -X main.builtBy=Homebrew"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lazyworktree"), "./cmd/lazyworktree"

    man1.install "lazyworktree.1"
    generate_completions_from_executable(bin/"lazyworktree", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyworktree --version")

    output = shell_output("#{bin}/lazyworktree worktrees get 2>&1", 1)
    assert_match "expected exactly one worktree argument", output
  end
end
