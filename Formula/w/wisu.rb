class Wisu < Formula
  desc "Blazingly fast, minimalist directory tree viewer"
  homepage "https://github.com/sh1zen/wisu"
  url "https://github.com/sh1zen/wisu/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "4e638701b312987cb9af6cde412bf7fc15d80ae42d234de7fd6ca648958557fa"
  license "Apache-2.0"
  head "https://github.com/sh1zen/wisu.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wisu --version")

    (testpath/"dir1").mkpath
    (testpath/"a.txt").write("a\n")
    (testpath/"dir1/b.txt").write("b\n")

    output = shell_output("#{bin}/wisu #{testpath}")
    assert_match "a.txt", output
    assert_match "dir1", output
    assert_match "b.txt", output
  end
end
