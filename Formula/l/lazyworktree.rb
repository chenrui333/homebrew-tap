class Lazyworktree < Formula
  desc "TUI for managing Git worktrees"
  homepage "https://github.com/chmouel/lazyworktree"
  url "https://github.com/chmouel/lazyworktree/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "ee078e3e4f1d81b701150c7737667f26864cf8266c1f5c7df33b45a69d6cf63d"
  license "Apache-2.0"
  head "https://github.com/chmouel/lazyworktree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0fc6b375d61045dc9237ad6bda748e1431a05408ccafae60571491d893a2c43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0fc6b375d61045dc9237ad6bda748e1431a05408ccafae60571491d893a2c43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0fc6b375d61045dc9237ad6bda748e1431a05408ccafae60571491d893a2c43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a72e420b7033414e7ce83c0bad14a3ed59128463395abebee21576cb038d0661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d70c43c78528f59054fc45edb5f8271064ea68749056726597c927c580f046"
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
