class Stree < Formula
  desc "Directory trees of AWS S3 Buckets"
  homepage "https://github.com/orangekame3/stree"
  url "https://github.com/orangekame3/stree/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "1edce8b1aa86a22a7ce4f8e1781eebf44ee838a70925eeaf45c7b35b3c22c03b"
  license "MIT"
  head "https://github.com/orangekame3/stree.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stree --version")

    output = shell_output("#{bin}/stree --directory-only test 2>&1", 1)
    assert_match "failed to initialize AWS session", output
  end
end
