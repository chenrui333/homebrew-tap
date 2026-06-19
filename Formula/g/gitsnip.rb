class Gitsnip < Formula
  desc "Download specific folders from a Git repository"
  homepage "https://github.com/dagimg-dot/gitsnip"
  url "https://github.com/dagimg-dot/gitsnip/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d5e3c7d75b1b5145128d92cdb56abe08b623af22d96aa520e2411b18a794e4c6"
  license "MIT"
  head "https://github.com/dagimg-dot/gitsnip.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87b3678fb6dd58ff5fa8283819df77af89fa61cf48021569eb03e7813c06ba4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b3678fb6dd58ff5fa8283819df77af89fa61cf48021569eb03e7813c06ba4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87b3678fb6dd58ff5fa8283819df77af89fa61cf48021569eb03e7813c06ba4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076df166460a02e7373c3729bb1301d75eb81984270a326b9ffcd4c6c53c7573"
    sha256 cellar: :any,                 x86_64_linux:  "d853c4e888c32e2b744e8a4bb84f109d29b6465b2ce517e3524422b6c2cef67f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/dagimg-dot/gitsnip/internal/cli.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gitsnip"
    generate_completions_from_executable(bin/"gitsnip", shell_parameter_format: :cobra)
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
