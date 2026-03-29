class Scanify < Formula
  desc "Transform PDFs to look like scanned documents"
  homepage "https://github.com/Francium-Tech/scanify"
  url "https://github.com/Francium-Tech/scanify/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c451e64ee496acdf562def65beaf6aadbde293471326bb6d3269ce46a7e10522"
  license "MIT"
  head "https://github.com/Francium-Tech/scanify.git", branch: "main"

  on_linux do
    depends_on "swift" => :build
    depends_on "imagemagick"
    depends_on "poppler"
  end

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/scanify"
  end

  test do
    (testpath/"input.pdf").write <<~PDF
      %PDF-1.1
      1 0 obj
      << /Type /Catalog /Pages 2 0 R >>
      endobj
      2 0 obj
      << /Type /Pages /Kids [3 0 R] /Count 1 >>
      endobj
      3 0 obj
      << /Type /Page /Parent 2 0 R /MediaBox [0 0 300 144] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>
      endobj
      4 0 obj
      << /Length 44 >>
      stream
      BT
      /F1 24 Tf
      72 72 Td
      (Hello Scanify) Tj
      ET
      endstream
      endobj
      5 0 obj
      << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>
      endobj
      xref
      0 6
      0000000000 65535 f
      0000000010 00000 n
      0000000062 00000 n
      0000000117 00000 n
      0000000243 00000 n
      0000000337 00000 n
      trailer
      << /Root 1 0 R /Size 6 >>
      startxref
      407
      %%EOF
    PDF

    assert_match version.to_s, shell_output("#{bin}/scanify --version")

    system bin/"scanify", "input.pdf", "output.pdf"
    assert_path_exists testpath/"output.pdf"
    assert_operator (testpath/"output.pdf").size, :>, 0
  end
end
