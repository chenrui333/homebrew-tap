class Sqd < Formula
  desc "SQL-like document editor"
  homepage "https://github.com/albertoboccolini/sqd"
  url "https://github.com/albertoboccolini/sqd/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "ee4586ad8200b4a06808b6ef0c8baf940664d993b233f7e74331d0529c193f34"
  license "MIT"
  head "https://github.com/albertoboccolini/sqd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8b95a6a1d294ba3789db357311be5d13ccf6e7d9471c167e84f5cafd1f4b806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8b95a6a1d294ba3789db357311be5d13ccf6e7d9471c167e84f5cafd1f4b806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8b95a6a1d294ba3789db357311be5d13ccf6e7d9471c167e84f5cafd1f4b806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b301070824d79ae62e63295cbe5eed00160c6d29bc9e39b04f4f0b9207970ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c5a56237451368808197b8770e14e89776ec28eb0e56a2ad24205f868bd16e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "."
  end

  test do
    (testpath/"sample.txt").write("alpha\nbeta\n")
    output = shell_output("#{bin}/sqd \"SELECT content FROM *.txt WHERE content = 'alpha'\"")
    assert_match "alpha", output
    assert_match version.to_s, shell_output("#{bin}/sqd --version")
  end
end
