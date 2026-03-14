class Deadbranch < Formula
  desc "Clean up stale git branches safely"
  homepage "https://github.com/armgabrielyan/deadbranch"
  url "https://github.com/armgabrielyan/deadbranch/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "c2b7dc20250bf4d6fe8505ab20b10f50dedf99b121ca682f4ee9ae19ca53972f"
  license "MIT"
  head "https://github.com/armgabrielyan/deadbranch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfbd37dc3b5534def226e9dd183136bd2b6bed93408c52a737c9cb0b27d78335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a19d35d6ae92c30e11e50fe7364eeb3a32499ea12445ff62f313fbbe83df3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "610c980f18cf8cef575f2321ddde816b59ad962bf21c67bd006e273df0e2cd2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff355e3b31ec49866fcd8048aa03b5e9fbc16925514ca0ff53590360d101c602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3d5781f15e551b19a2bba91f0dcccb97d3d9bf5f72012f768afb8a9e13867a9"
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
