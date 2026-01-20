class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "870e12828141eebef55a219641d26d1b736ec9d09eb82e546e13b641e51aff6c"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gorae"
  end

  test do
    assert_match "Root directory to start in", shell_output("#{bin}/gorae --help 2>&1")
  end
end
