class GitSurgeon < Formula
  desc "Surgical Git hunk control for AI agents"
  homepage "https://github.com/raine/git-surgeon"
  url "https://github.com/raine/git-surgeon/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "c67426d0111780b7f13d45554192da6253b3bb676961449d60110af17e83f8ea"
  license "MIT"
  head "https://github.com/raine/git-surgeon.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "skills"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-surgeon --version")

    system "git", "init", "--quiet"
    system "git", "config", "user.email", "test@brew.sh"
    system "git", "config", "user.name", "Homebrew Test"
    (testpath/"example.txt").write "original line\n"
    system "git", "add", "example.txt"
    system "git", "commit", "--quiet", "-m", "Initial fixture"
    (testpath/"example.txt").atomic_write "modified line\n"
    original_diff = shell_output("git diff")
    output = shell_output("#{bin}/git-surgeon hunks")
    assert_match "example.txt", output
    assert_match(/^[0-9a-f]{7} example\.txt/, output)
    assert_match original_diff, shell_output("git diff")
  end
end
