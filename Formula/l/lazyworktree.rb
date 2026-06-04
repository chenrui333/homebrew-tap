class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.46.1.tar.gz"
  sha256 "ec0b33f789a95c543f8d565f38680b3366dd5092bcb19331321efb846f9ea0a6"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad83d9c80ec6d9a6d02f87f0ec750ba08b992b1ba83728790e9b16d856369b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad83d9c80ec6d9a6d02f87f0ec750ba08b992b1ba83728790e9b16d856369b6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad83d9c80ec6d9a6d02f87f0ec750ba08b992b1ba83728790e9b16d856369b6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9c6f3b8af9b3d91ab313464262fd40764ca5d51c104c7b60b7dde6ab14b159f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2803a59a95ae305e662a1445594407bbc7b108a435140284f2b592357421303"
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
