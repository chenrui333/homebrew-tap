class Doxx < Formula
  desc "Terminal document viewer for .docx files"
  homepage "https://github.com/bgreenwell/doxx"
  url "https://github.com/bgreenwell/doxx/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "6923cefa432a08adacedeb105902d47858f0ceea51b00e21e8b10117d86ca9e6"
  license "MIT"
  head "https://github.com/bgreenwell/doxx.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"generate_test_docs"
    assert_path_exists testpath/"tests/fixtures/minimal.docx"

    output = shell_output("#{bin}/doxx #{testpath}/tests/fixtures/minimal.docx")
    assert_match <<~EOS, output
      Document: minimal
      Pages: 1
      Words: 26
    EOS
  end
end
