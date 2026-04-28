class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.45.1.tar.gz"
  sha256 "55ea155a20bf708fd267f3e64719693669b9330f6ced157e8cb7ad86a41eb004"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab23f747775cf42549255f0ebd897b7b11de3ef2f52c96f7cb9059f160a1f165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab23f747775cf42549255f0ebd897b7b11de3ef2f52c96f7cb9059f160a1f165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab23f747775cf42549255f0ebd897b7b11de3ef2f52c96f7cb9059f160a1f165"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aad4594724895449742266ca20a46206e2201024d6823b711f3c5e5dcfb9cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e8d4db6ae67cce4b882e88106f5592e4c6726ade7d2b9869f0a7291613ac0b8"
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
