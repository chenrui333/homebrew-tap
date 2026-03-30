class Deadbranch < Formula
  desc "Clean up stale git branches safely"
  homepage "https://github.com/armgabrielyan/deadbranch"
  url "https://github.com/armgabrielyan/deadbranch/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6a4b45018f3daae0302469d6a305a7c143bc207284210310ca5532c2ee6536f3"
  license "MIT"
  head "https://github.com/armgabrielyan/deadbranch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fb7e50c81431ff85fe125e19419d5664f0cbe8f56be42c6a1f63b55364e91a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc4c7f0d3b6ac473c6016519cfe1e0dc146a7cce86820cf181d1ac4e0cd62230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94bbb9c5e117ff2a485b298c246ac0a4871c024c4b44fef78ae464fc9eebd509"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "188f825887759809a44b20409c02b566ff0211f02e091d36a57f56c5feb6e201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c7b9be4f008c007d43f8645f722a6201754d7a5961532a72d0620ce0d98f35"
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
