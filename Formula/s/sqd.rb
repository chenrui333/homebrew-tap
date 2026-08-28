class Sqd < Formula
  desc "SQL-like document editor"
  homepage "https://github.com/albertoboccolini/sqd"
  url "https://github.com/albertoboccolini/sqd/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "57bf15a862b36e4a33e6407972ecbaa04e6571f156d7db44d8123e40bd69bfea"
  license "MIT"
  head "https://github.com/albertoboccolini/sqd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c5fb2bcf09173b0f520780dcf7e18837fdf07500d69d210f903744b0bfd1d69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c5fb2bcf09173b0f520780dcf7e18837fdf07500d69d210f903744b0bfd1d69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c5fb2bcf09173b0f520780dcf7e18837fdf07500d69d210f903744b0bfd1d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f543b552a185d3370dfdba3b1624167a77c92673efcae9d3d39270de2752658e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c294d6bc017b4793b6411c99106a8f9eb4d70a199d4a5d4143f69f62c65b0e0"
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
