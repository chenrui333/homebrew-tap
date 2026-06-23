class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "d743006e70ff2be246c852f21af8304d596186fe9818f6b90824761af7eeec8a"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e4fcd2ae858affdd20f0a0e3fc51ad03bbdeb4a84481d3022cd8b50e8b81567"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e4fcd2ae858affdd20f0a0e3fc51ad03bbdeb4a84481d3022cd8b50e8b81567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e4fcd2ae858affdd20f0a0e3fc51ad03bbdeb4a84481d3022cd8b50e8b81567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98a5f6c6d7c1a68679bd4e584c1f08ccc83d1b92f49ce88e0cfa974a28b55564"
    sha256 cellar: :any,                 x86_64_linux:  "15a549c58ffd8f7a70f05548fec37703d90f66bede3298c9cb891f26827fac32"
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
