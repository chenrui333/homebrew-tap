class Deadbranch < Formula
  desc "Clean up stale git branches safely"
  homepage "https://github.com/armgabrielyan/deadbranch"
  url "https://github.com/armgabrielyan/deadbranch/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6a4b45018f3daae0302469d6a305a7c143bc207284210310ca5532c2ee6536f3"
  license "MIT"
  head "https://github.com/armgabrielyan/deadbranch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fc90437a48528beb69440bddc048856dbbf0c2afcfedf3aee93b4580cbbe744"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6075cdde69d205380b5f101c6a49a0d908c2a9fcf72d4de7d6730313038776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99dbe42d91f8c63940a3fc14cecefc32659bd2a71b3d4dfb47479b6f713bf883"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fec32eab68ecaa08cc4ce62ea70e72d66e49936a5fa6b2318f31b970f6e8edad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39cac5fb51f71fc3b069e4ba942ef665d6cbccca541e135f6552ccae537ea659"
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
