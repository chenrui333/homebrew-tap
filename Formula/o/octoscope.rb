class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "d7bbc4482be43fc18035ca3992b11517062bf92ae320abcc878a377814c7b63d"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3746ccc6bd6e29ef3a92bcf474a0af5a48bf09d1efc1921ad5090da435b3698b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3746ccc6bd6e29ef3a92bcf474a0af5a48bf09d1efc1921ad5090da435b3698b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3746ccc6bd6e29ef3a92bcf474a0af5a48bf09d1efc1921ad5090da435b3698b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed95c290c12fc2ae9d97b853f4eceab26f6be9daa203ae83c182ef94f0e2a104"
    sha256 cellar: :any,                 x86_64_linux:  "33f062deb38eebec4e6e102e9509a6bf3e3a94884ce197808a97ac410b0ee376"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output
  end
end
