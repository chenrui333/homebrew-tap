class Sqd < Formula
  desc "SQL-like document editor"
  homepage "https://github.com/albertoboccolini/sqd"
  url "https://github.com/albertoboccolini/sqd/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "57bf15a862b36e4a33e6407972ecbaa04e6571f156d7db44d8123e40bd69bfea"
  license "MIT"
  head "https://github.com/albertoboccolini/sqd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "380d03d14f6731e7fb7eefc70f97a62b1e42829f87f83ad8d20bc318bff6e58a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "380d03d14f6731e7fb7eefc70f97a62b1e42829f87f83ad8d20bc318bff6e58a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "380d03d14f6731e7fb7eefc70f97a62b1e42829f87f83ad8d20bc318bff6e58a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f0e618287dfebb569b4b7a740ac0151ccfb86d129265891218526b20286e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a3094707928b2e88b247fa3ef593e84e6a05da22a7bba4ab916ce09866dcf4b"
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
