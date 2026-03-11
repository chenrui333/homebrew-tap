class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "42bc938f87a128e29098c5a8c8486795cac14a3c52d40b914b14d8f7a8c6438c"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28971265e519cf6fa1583f562ff1a381ff201fcd1dbd48417c01478c9404049d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28971265e519cf6fa1583f562ff1a381ff201fcd1dbd48417c01478c9404049d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28971265e519cf6fa1583f562ff1a381ff201fcd1dbd48417c01478c9404049d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c4af4aaaf6a0e0037d83f89b170e750ae8e3a72dd9d8f48f9930184384c2e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2f4c7d8c675cb5b2bdb22d4df68860e7a326b38b5a6d07bc195db599b2f40f8"
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
