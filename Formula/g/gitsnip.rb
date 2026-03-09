class Gitsnip < Formula
  desc "Download specific folders from a Git repository"
  homepage "https://github.com/dagimg-dot/gitsnip"
  url "https://github.com/dagimg-dot/gitsnip/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d5e3c7d75b1b5145128d92cdb56abe08b623af22d96aa520e2411b18a794e4c6"
  license "MIT"
  head "https://github.com/dagimg-dot/gitsnip.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/dagimg-dot/gitsnip/internal/cli.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gitsnip"
    generate_completions_from_executable(bin/"gitsnip", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match "GitSnip #{version}", shell_output("#{bin}/gitsnip version")

    repo = testpath/"repo"
    repo.mkdir
    (repo/"docs/snippet").mkpath
    (repo/"docs/snippet/hello.txt").write("hello from gitsnip\n")

    system "git", "init", "-b", "main", repo
    system "git", "-C", repo, "config", "user.name", "Homebrew"
    system "git", "-C", repo, "config", "user.email", "brew@example.com"
    system "git", "-C", repo, "add", "."
    system "git", "-C", repo, "commit", "-m", "init"

    output_dir = testpath/"output"
    system bin/"gitsnip", repo.to_s, "docs/snippet", output_dir.to_s, "--method", "sparse", "--quiet"

    assert_equal "hello from gitsnip\n", (output_dir/"hello.txt").read
  end
end
