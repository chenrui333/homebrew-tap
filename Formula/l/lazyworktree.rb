class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "42bc938f87a128e29098c5a8c8486795cac14a3c52d40b914b14d8f7a8c6438c"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e3ff15a25a3a77eec3b4178d3439ea5433603d1d34088f7dc4100e44826ea49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e3ff15a25a3a77eec3b4178d3439ea5433603d1d34088f7dc4100e44826ea49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3ff15a25a3a77eec3b4178d3439ea5433603d1d34088f7dc4100e44826ea49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc57a8bbe23a289fe2ec9c81ea38a85f0108d9835e72d3c33726c9c87ab641d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "760fe74c90e946f0f7ca48abb11d235c773910d5782b92bb20ff1ba593744974"
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
