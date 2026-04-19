class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "40fabbea88c6a37fafe69f94a91d80004588eee569a0805c225c5f5960dbac4c"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7415e744ca7ff816a995a3be7f60b4b8c3e8b71a690d00e3d3bafb2b8f99bf1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7415e744ca7ff816a995a3be7f60b4b8c3e8b71a690d00e3d3bafb2b8f99bf1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7415e744ca7ff816a995a3be7f60b4b8c3e8b71a690d00e3d3bafb2b8f99bf1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1910949657ba7b839c86fda4bd1018b3de7580bdac3fcbcef6e1622bcb7ca268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25fd0013360ed2b6586faf41bbfb94c0e2c3d73855bb22f092c9052f3be3374a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gorae"
  end

  test do
    assert_match "Root directory to start in", shell_output("#{bin}/gorae --help 2>&1")
  end
end
