class Markpdf < Formula
  desc "Watermark PDF files using image or text"
  homepage "https://github.com/ajaxray/markpdf"
  url "https://github.com/ajaxray/markpdf/archive/refs/tags/1.0.1.tar.gz"
  sha256 "df31ae2432b0b321771829a44dce8335642fe616ab1f40a2e80663326683226d"
  license "Apache-2.0"
  head "https://github.com/ajaxray/markpdf.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd98919c2db98b846b4bd2433d6fdb6b88128d2d2de4501f4aee92f69aa3cea1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd98919c2db98b846b4bd2433d6fdb6b88128d2d2de4501f4aee92f69aa3cea1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f310545e12f881a51b6a4fcb93dfc1843c6161455eccd5cbac435f48d0f7df2"
    sha256 cellar: :any,                 x86_64_linux:  "2eec786abcfac510a4534ee7c021fc114e4cf69735298de4f2dcabb9dae5f005"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
