class Gitsnip < Formula
  desc "Download specific folders from a Git repository"
  homepage "https://github.com/dagimg-dot/gitsnip"
  url "https://github.com/dagimg-dot/gitsnip/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d5e3c7d75b1b5145128d92cdb56abe08b623af22d96aa520e2411b18a794e4c6"
  license "MIT"
  head "https://github.com/dagimg-dot/gitsnip.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fd3e70e13030ef490ddc878f213becaa8ef397c8fae07683174dd7c8448220b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fd3e70e13030ef490ddc878f213becaa8ef397c8fae07683174dd7c8448220b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd3e70e13030ef490ddc878f213becaa8ef397c8fae07683174dd7c8448220b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2cbf575ef6e7f4e406d3602f702e65bdd5d943fa07b3f010611474b7a97f081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86b7b3b188029b4233f92d5f8f51f0aced96d5a5b3fcb625cd8bc4a65e6ef297"
  end

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
