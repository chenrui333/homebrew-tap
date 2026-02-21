class Deadbranch < Formula
  desc "Clean up stale git branches safely"
  homepage "https://github.com/armgabrielyan/deadbranch"
  url "https://github.com/armgabrielyan/deadbranch/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "b0223656c201e05cb17f6167afbc73c69c682f4b9053b9e9f8e46d9156f7f010"
  license "MIT"
  head "https://github.com/armgabrielyan/deadbranch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43d7fff7f317f922bd154ee78475ebaebb2fdd2cdd3792335b6771666557c22f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f34e5b5ad0153d141569d94de3bfc30b1f7646058a67813b3113af051b68ca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ea59d284b889d5e173e204c520cb4611065d6010907d484657090dc12d229d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba6ffd3761143dcd531821eab29bd6a6bbe55d3733f826e8f10d7c95982df829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b764794942bcf1fb0bb4539381cfda3ece88a2ca40cff2d9114c17a9fa0dae5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
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
