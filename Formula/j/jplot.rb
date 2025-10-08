class Jplot < Formula
  desc "ITerm2 expvar/JSON monitoring tool"
  homepage "https://github.com/rs/jplot"
  url "https://github.com/rs/jplot/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "e2d1aa4cf81a61cdcea0b190f18a8ee7502093faf77c48f54c2741b457b4f298"
  license "MIT"
  revision 1
  head "https://github.com/rs/jplot.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90141a1176b95c928e920e8f77d9fbbbc1bb3a594a5da0efbb0abb2a6a84656c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fc3312b47204c277e47106b5ce12aac525edab6c0c0f09d84394028938e2f07"
    sha256 cellar: :any_skip_relocation, ventura:       "4590f23069e574eb32e7e33cdb0eb457ed73075239a5f4c0bcc33f2340ba94ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d8c21d24e5e01a908dc5e813f54c021f5fc9917d0b0f417cc98c9a4fecff88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/jplot --help 2>&1")
    assert_match "Usage: jplot [OPTIONS] FIELD_SPEC [FIELD_SPEC...]", output
  end
end
