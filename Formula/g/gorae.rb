class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "40fabbea88c6a37fafe69f94a91d80004588eee569a0805c225c5f5960dbac4c"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd718758eae06c2bfc5325d37d18958b5cec3141525895207c1c269aa323f65b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd718758eae06c2bfc5325d37d18958b5cec3141525895207c1c269aa323f65b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd718758eae06c2bfc5325d37d18958b5cec3141525895207c1c269aa323f65b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72f8cfba6494784257ccb53d952e21185dd47b132574bccda8f68f7aa472e3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909d306198f7d5a49d404da30788d362ea00acab4a53e0ab5d14dd95f7fab284"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gorae"
  end

  test do
    assert_match "Root directory to start in", shell_output("#{bin}/gorae --help 2>&1")
  end
end
