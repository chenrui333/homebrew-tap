class Deadbranch < Formula
  desc "Clean up stale git branches safely"
  homepage "https://github.com/armgabrielyan/deadbranch"
  url "https://github.com/armgabrielyan/deadbranch/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "82cdce4c60cac5a57ba2c858162648661a1fdc3645844404fbd153a5d6e5cb25"
  license "MIT"
  head "https://github.com/armgabrielyan/deadbranch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "489d26f09ae1f95ad57e07098e7cd4b50f2e256ccc3681f5f5153a79386835c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5066b85ca5c98264d197ef76fc352276a110af0eec888d5e3e99bf4b370e54d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "640f14f154398ee572a3f8b213bf7e315247666919fffefceb52455d658e0439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4227582821137d8f4eec2203f09e49051af91bf458172dd7deee4d66b561a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c518ecfa6d7913e7397becd281be189d387f8348b9bad0f12f29e034cacc0bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deadbranch --version")

    system "git", "init"
    system "git", "branch", "-m", "main"
    system "git", "config", "user.name", "Test User"
    system "git", "config", "user.email", "test@example.com"

    (testpath/"README.md").write("main\n")
    system "git", "add", "README.md"
    init_commit_env = "GIT_AUTHOR_DATE='2000-01-01T00:00:00Z' " \
                      "GIT_COMMITTER_DATE='2000-01-01T00:00:00Z'"
    system "sh", "-c", "#{init_commit_env} git commit -m init"

    system "git", "checkout", "-b", "feature/old"
    (testpath/"feature.txt").write("old branch\n")
    system "git", "add", "feature.txt"
    feature_commit_env = "GIT_AUTHOR_DATE='2000-01-02T00:00:00Z' " \
                         "GIT_COMMITTER_DATE='2000-01-02T00:00:00Z'"
    system "sh", "-c", "#{feature_commit_env} git commit -m feature"

    system "git", "checkout", "main"
    system "git", "merge", "--no-ff", "feature/old", "-m", "merge feature"

    output = shell_output("#{bin}/deadbranch list --days 1 --local --merged")
    assert_match "feature/old", output

    dry_run_output = shell_output("#{bin}/deadbranch clean --days 1 --local --dry-run")
    assert_match "feature/old", dry_run_output
  end
end
