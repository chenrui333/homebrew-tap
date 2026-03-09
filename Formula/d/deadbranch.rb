class Deadbranch < Formula
  desc "Clean up stale git branches safely"
  homepage "https://github.com/armgabrielyan/deadbranch"
  url "https://github.com/armgabrielyan/deadbranch/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "071c6cb141184f65a1ec670ed3abcfe22a559861345485ce3d39cdad6311d63c"
  license "MIT"
  head "https://github.com/armgabrielyan/deadbranch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa00922b103c429ee26a768bd2624972251a2f1d577fa0cb1b1b2f39efa2b62a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d99b7709061bf3acc94f0bb537f40b539c4db1444126b31c489398948fbc6a83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2123128303a1e9d16748d3e44f4aa317a3121cb3c253c20c7a90c5500bae48da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ca179c87fd359b3c59f40489dd20259ab56b76660d22127eabde1a56a0ad850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36960ca14642d9d0fe8f2f5d7144fbdbec05a92f7abe9b20f9fb9c371ce230ab"
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
