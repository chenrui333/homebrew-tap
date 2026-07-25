class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "84b025fb6b55f5c0185466448491fb7d74df9f50f70197f715691d03e0d0eec8"
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

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test User"
    (testpath/"README.md").write "hello\n"
    system "git", "add", "README.md"
    system "git", "commit", "-m", "init"

    output = shell_output("#{bin}/lazyworktree list --main --json")
    assert_match '"is_main": true', output
    assert_match testpath.to_s, output
  end
end
