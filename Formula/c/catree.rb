class Catree < Formula
  desc "Recursively display file contents from directories"
  homepage "https://github.com/luislve17/catree"
  url "https://github.com/luislve17/catree/archive/refs/tags/base-release-1.2.tar.gz"
  sha256 "804d095dbd38fb14e5a125b454af5c1e33f7867affd878b3567968324fd60947"
  license "MIT"
  head "https://github.com/luislve17/catree.git", branch: "main"

  def install
    bin.install "catree"
  end

  test do
    (testpath/"keep.txt").write("hello from catree")
    (testpath/"skip.log").write("ignore me")

    output = shell_output("#{bin}/catree -inc txt")
    assert_match "hello from catree", output
    refute_match "ignore me", output

    assert_match version.to_s, shell_output("#{bin}/catree -v")
  end
end
