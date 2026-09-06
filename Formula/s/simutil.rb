class Simutil < Formula
  desc "Manage mobile simulators and devices"
  homepage "https://github.com/dungngminh/simutil"
  url "https://github.com/dungngminh/simutil/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "be4d65538dafde05622994b50269a8f2237724d2659b517ea9084fcc49bdeb19"
  license "MIT"
  head "https://github.com/dungngminh/simutil.git", branch: "main"

  depends_on "dart-sdk" => :build

  def install
    system "dart", "pub", "get", "--enforce-lockfile"
    bin.mkpath
    system "dart", "compile", "exe", "bin/simutil.dart", "-o", bin/"simutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/simutil version")
    output = shell_output("#{bin}/simutil invalid-command 2>&1", 255)
    assert_match 'Could not find a command named "invalid-command"', output
  end
end
