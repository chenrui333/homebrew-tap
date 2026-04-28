class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "ee078e3e4f1d81b701150c7737667f26864cf8266c1f5c7df33b45a69d6cf63d"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f139945bd280c55e5cbacee94722c05ec52f7f8ee1fefb3fb32d578e62c1f31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f139945bd280c55e5cbacee94722c05ec52f7f8ee1fefb3fb32d578e62c1f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f139945bd280c55e5cbacee94722c05ec52f7f8ee1fefb3fb32d578e62c1f31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c4225ce642f00093053ddd4014032a73748f2004b87739a4151cc497f2633f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53f91766d671e468c75ded36c7cf8c422c476d4ba25669370e67dab7e70c8cf6"
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
