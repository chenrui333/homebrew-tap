class Scanify < Formula
  desc "Transform PDFs to look like scanned documents"
  homepage "https://github.com/Francium-Tech/scanify"
  url "https://github.com/Francium-Tech/scanify/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c451e64ee496acdf562def65beaf6aadbde293471326bb6d3269ce46a7e10522"
  license "MIT"
  head "https://github.com/Francium-Tech/scanify.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5bfe8eb147bc81b2f62b49e9c3e3c04209dd1ed7b83fceeb831d3e6f9027c5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de84816007dbebb0ff67e894c5981dac4cb89a4dc56cab5b361db3ad4c7fe48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f8965aa1098f6081a89923ffdaa117259910d1156fae88b4583ab8035564929"
    sha256 cellar: :any_skip_relocation, sequoia:       "2b70033de6a471a55153a7b92da07864583e1e4105720c6b7b2e1251b12e92c5"
    sha256                               arm64_linux:   "8a0611e0384424ff1728caf6cb92f6512f049aa989d25a9e31ef0eb470523b55"
    sha256                               x86_64_linux:  "4045f1f438d41f25008fe5565aaf39a63c09a0bccd2593b554a8b15691f91cdf"
  end

  on_linux do
    depends_on "imagemagick"
    depends_on "poppler"
    depends_on "swift"
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
