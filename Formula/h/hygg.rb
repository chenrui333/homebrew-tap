class Hygg < Formula
  desc "Simplifying the way you read"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.16.tar.gz"
  sha256 "9b6eb2e3c9f9ffc7fb98637765690dd0e3a7b292c4580c3b236bbc99bfa29e14"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0750d6b3fd6e17b70404d5bd554fab423f4bbd4c5434a07421f59e3616b9ff60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdc3f7de14778553a89b33c6ded0f7347d5c0081fa4db7046e2a0af881255456"
    sha256 cellar: :any_skip_relocation, ventura:       "7b38c9956761723ea7436a0f24d5a1b1bf3425b035db89adb87d6ba43f2ae40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6216c3e025d53eef0156297734868bd031da72c524cdaf6d7375ecb8bc8e1947"
  end

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
