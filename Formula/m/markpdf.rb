class Markpdf < Formula
  desc "Watermark PDF files using image or text"
  homepage "https://github.com/ajaxray/markpdf"
  url "https://github.com/ajaxray/markpdf/archive/refs/tags/1.0.1.tar.gz"
  sha256 "df31ae2432b0b321771829a44dce8335642fe616ab1f40a2e80663326683226d"
  license "Apache-2.0"
  head "https://github.com/ajaxray/markpdf.git", branch: "master"

  depends_on "go" => :build

  def install
    inreplace "main.go", "1.0.0", version.to_s
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/markpdf --version")

    output = shell_output("#{bin}/markpdf #{test_fixtures("test.pdf")} " \
                          "WATERMARK #{testpath/"output.pdf"} --verbose")
    assert_match "Pdf version 1.6", output
    assert_path_exists testpath/"output.pdf"
  end
end
