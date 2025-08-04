class Lstr < Formula
  desc "Fast, minimalist directory tree viewer"
  homepage "https://github.com/bgreenwell/lstr"
  url "https://github.com/bgreenwell/lstr/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "9a59c59e3b4a0a1537f165a4818daa7cf1ee3feb689eaf8c495f70f280c3e547"
  license "MIT"
  head "https://github.com/bgreenwell/lstr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lstr --version")

    (testpath/"test_dir/file1.txt").write "Hello, World!"
    assert_match "file1.txt", shell_output("#{bin}/lstr test_dir")
  end
end
