class Sqd < Formula
  desc "SQL-like document editor"
  homepage "https://github.com/albertoboccolini/sqd"
  url "https://github.com/albertoboccolini/sqd/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "9e86925c186d8b2b3fa8f6f5612a2bb0eff513a2b37d3eef6f452fcc33e1b6a3"
  license "MIT"
  head "https://github.com/albertoboccolini/sqd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "867c3cd35c98f355ba7824b8a5fc99d4796cb9cb560b6d431a9c26ff6782caff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "867c3cd35c98f355ba7824b8a5fc99d4796cb9cb560b6d431a9c26ff6782caff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "867c3cd35c98f355ba7824b8a5fc99d4796cb9cb560b6d431a9c26ff6782caff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5c30f761ef759ef2e6d17ebd88c71ce59c4d011a9cddcfa6d4e8d36d96ab2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a2f6ae4e16d0e70473782a19c682d322aa85738cc4bdeb6301c881191ae8da"
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
