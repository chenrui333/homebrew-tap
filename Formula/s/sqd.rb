class Sqd < Formula
  desc "SQL-like document editor"
  homepage "https://github.com/albertoboccolini/sqd"
  url "https://github.com/albertoboccolini/sqd/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "9e86925c186d8b2b3fa8f6f5612a2bb0eff513a2b37d3eef6f452fcc33e1b6a3"
  license "MIT"
  head "https://github.com/albertoboccolini/sqd.git", branch: "main"

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
