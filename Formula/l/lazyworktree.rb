class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "ec14ce69c62eb7baaef6821874710c73e68071d88adef83008ed2256f79a5f8f"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7fcb7cdf0957cc9bbde9ef96ce5b5012c2e987ed529d0c0ddc9f162d7479f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7fcb7cdf0957cc9bbde9ef96ce5b5012c2e987ed529d0c0ddc9f162d7479f66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7fcb7cdf0957cc9bbde9ef96ce5b5012c2e987ed529d0c0ddc9f162d7479f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e97c575fa5426f6ce673ca0702dbfa3b7508d9d1e1d78bb06184d481f0ee9bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2190cd99649437c09ce4f0124f38d7ddd42439b4ab71496d7a1b7a476a1931c"
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
