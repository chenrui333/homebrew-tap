class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "01d3f737424f9e8fff9b847426548f0fc53e5e8c97c53da4b1def6fa06095bdf"
  license "Apache-2.0"
  revision 1
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

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
