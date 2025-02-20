class Mln < Formula
  desc "Modern replacement for `ln`"
  homepage "https://github.com/tkmru/mln"
  url "https://github.com/tkmru/mln/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8d57a09b95be6bd24f7c7c90be19e6ddf94640d153fd157f41282ee64c767dfc"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"testfile").write("This is a test file")
    system bin/"mln", "testfile", "testlink"

    assert_predicate testpath/"testlink", :symlink?
    assert_equal (testpath/"testfile").read, (testpath/"testlink").read
  end
end
