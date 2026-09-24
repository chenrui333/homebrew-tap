class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.50.1.tar.gz"
  sha256 "51fcb3b6e215a869fbb8e25b4ba40666fb2e15552e45f890511e173c9b6107ec"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c743cda6334058c3f51da8994615af42c17c73b23c4f863e511f9575b91923e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c743cda6334058c3f51da8994615af42c17c73b23c4f863e511f9575b91923e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c743cda6334058c3f51da8994615af42c17c73b23c4f863e511f9575b91923e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0fc03136ce89fb4d35f1049dea4b71c5b7cd20675d3ad37823716956199d1e7"
    sha256 cellar: :any,                 x86_64_linux:  "cf515be4acc755ffe8ee9d5d6b8e1c23aefa5ffad597d2e48e86f397751dba9a"
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
