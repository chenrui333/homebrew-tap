class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "870e12828141eebef55a219641d26d1b736ec9d09eb82e546e13b641e51aff6c"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb9a2e4479dbe4e523ab99a10427f1c24491614ac20be4966189385d73ba8de4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb9a2e4479dbe4e523ab99a10427f1c24491614ac20be4966189385d73ba8de4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb9a2e4479dbe4e523ab99a10427f1c24491614ac20be4966189385d73ba8de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c3a36163d491175cdfde6d7f19913e1a6743573017541ed7a3c39be38693e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1d6ecb61b776850352ea50e2abe5598d09d4f95d66332f0e4a88249f8d6f993"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gorae"
  end

  test do
    assert_match "Root directory to start in", shell_output("#{bin}/gorae --help 2>&1")
  end
end
