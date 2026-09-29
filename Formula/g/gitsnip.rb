class Gitsnip < Formula
  desc "Download specific folders from a Git repository"
  homepage "https://github.com/dagimg-dot/gitsnip"
  url "https://github.com/dagimg-dot/gitsnip/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "6e632e65536cec23be7cf4fdc90bca524d3654a9449f9897b5b8d62d7cf2edde"
  license "MIT"
  head "https://github.com/dagimg-dot/gitsnip.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "306ce77c808eb9908e5be3caac7c3e53d03a3b5a991167f31bb5a14e0da6747c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "306ce77c808eb9908e5be3caac7c3e53d03a3b5a991167f31bb5a14e0da6747c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96fcff3cf2ace403afca7eba060d83c8d97b8295fa8f8f13f2c29cbe8fb14770"
    sha256 cellar: :any,                 x86_64_linux:  "08d6ca9f455ec08012fb6c9a097301b956bb6327529693f5a974dabc04852029"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/dagimg-dot/gitsnip/internal/cli.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gitsnip"
    generate_completions_from_executable(bin/"gitsnip", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsnip version")

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
    system bin/"gitsnip", "file://#{repo}", "docs/snippet", "-o", output_dir.to_s,
           "--method", "sparse", "--quiet"

    assert_equal "hello from gitsnip\n", (output_dir/"hello.txt").read
  end
end
