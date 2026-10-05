class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.50.1.tar.gz"
  sha256 "51fcb3b6e215a869fbb8e25b4ba40666fb2e15552e45f890511e173c9b6107ec"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "087d807fea41afb622b4df5a28a2fb2a1343fc575c6996bda5768e09f4c07144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "087d807fea41afb622b4df5a28a2fb2a1343fc575c6996bda5768e09f4c07144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53f782a50dc652e3f4cbca87ddd2520ab383406b7be75399e681d2d2c042ce52"
    sha256 cellar: :any,                 x86_64_linux:  "411ed37cd96fd349e2f42a25166ff4390ee6dfc56b81f40f5d6af075eb2ab704"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
