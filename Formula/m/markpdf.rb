class Markpdf < Formula
  desc "Watermark PDF files using image or text"
  homepage "https://github.com/ajaxray/markpdf"
  url "https://github.com/ajaxray/markpdf/archive/refs/tags/1.0.1.tar.gz"
  sha256 "df31ae2432b0b321771829a44dce8335642fe616ab1f40a2e80663326683226d"
  license "Apache-2.0"
  head "https://github.com/ajaxray/markpdf.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2a4417a11d87a93e1881a8f15117cd89601a623f2ec58816b311470c570f467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356d4b0ea18601a782746eab7e8a5a1fa4825a94d315d581b174fcd62a6fc1b0"
    sha256 cellar: :any_skip_relocation, ventura:       "80eddc3f07c339ef453cca45027c2df7703af26a66bc8e71f260f9a3dde72e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd16545942e2b8950006a639a2940a6998a690a2c0c3f5b904a33121d0c59f5"
  end

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
