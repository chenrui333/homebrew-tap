class Deadbranch < Formula
  desc "Clean up stale git branches safely"
  homepage "https://github.com/armgabrielyan/deadbranch"
  url "https://github.com/armgabrielyan/deadbranch/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "230248422641e3af844ab617c1e2079c0638e63ded003bbf4e5407b6bb2003d7"
  license "MIT"
  head "https://github.com/armgabrielyan/deadbranch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb89e17f1e08f6e5c55bc6d27bdd2f19589fc851146e2b1caa0defdb29c30ea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6717cef533aca4416426bd8f538a3ec9d18f415993905678ba3b52ab64a7394"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bf63f59c2d5bb629a0d1ce683e791e4999075ad00413424c5b3a1a41c11bcee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "896d2f3ba9cdd739f200e5f6fd43f874b95ff99b90ebd067b7cbd692e55fc3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd31dd75e9b237c069a7182798a22db4e7c10ddfd50b47df0626764fc8b56a3"
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
