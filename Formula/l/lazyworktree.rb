class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "20db53c5cc2a314a5bac027c638010ae1c9e594eeb0ef0f317a488ee397b5446"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "792a9bd5a5c11cfa30cbd15978e10a9b58972a9357cecf288cf01602a7003310"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "792a9bd5a5c11cfa30cbd15978e10a9b58972a9357cecf288cf01602a7003310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "792a9bd5a5c11cfa30cbd15978e10a9b58972a9357cecf288cf01602a7003310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6372e253854ce5600a330f79ba67c6090eb5743f6bf7cb9b04180e59f1ca4344"
    sha256 cellar: :any,                 x86_64_linux:  "2739b2b46f97020cd90232a87b6b652aeda21b8e7a1cdaeb870d087fd43bb4fa"
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
