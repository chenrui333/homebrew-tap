class Hygg < Formula
  desc "Simplifying the way you read"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.15.tar.gz"
  sha256 "46422bf7c5d8fcf0cbf0e5a4b7a31a33159f768b8f4eed937505c6a53d0ec945"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  depends_on "rust" => :build
  depends_on "ocrmypdf"

  def install
    system "cargo", "install", *std_cargo_args(path: "hygg")
  end

  test do
    resource "test_pdf" do
      url "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
      sha256 "3df79d34abbca99308e79cb94461c1893582604d68329a41fd4bec1885e6adb4"
    end

    testpath.install resource("test_pdf")
    output = shell_output("#{bin}/hygg --ocr #{testpath}/dummy.pdf 2>&1")
    assert_match "Dummy PDF file", output
  end
end
