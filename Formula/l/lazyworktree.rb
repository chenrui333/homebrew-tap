class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.46.1.tar.gz"
  sha256 "ec0b33f789a95c543f8d565f38680b3366dd5092bcb19331321efb846f9ea0a6"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1215470c532cca51413ab14c06d0f92ac370f4c2a24913c89caaa810392489c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1215470c532cca51413ab14c06d0f92ac370f4c2a24913c89caaa810392489c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1215470c532cca51413ab14c06d0f92ac370f4c2a24913c89caaa810392489c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bcbddf9d7de7ccbd3f504bae5e8f8e330f4ff27619908c1a75c1790889e9c18"
    sha256 cellar: :any,                 x86_64_linux:  "7e9102271d2716e0a05f3095f203f9e435c5ee4b14a70ac1d3f776550714c99e"
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
