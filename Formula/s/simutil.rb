class Simutil < Formula
  desc "Manage mobile simulators and devices"
  homepage "https://github.com/dungngminh/simutil"
  url "https://github.com/dungngminh/simutil/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "be4d65538dafde05622994b50269a8f2237724d2659b517ea9084fcc49bdeb19"
  license "MIT"
  head "https://github.com/dungngminh/simutil.git", branch: "main"

  depends_on "dart-sdk"

  def install
    system "dart", "pub", "get", "--enforce-lockfile"
    libexec.mkpath
    system "dart", "compile", "aot-snapshot", "bin/simutil.dart", "-o", libexec/"simutil.aot"
    (bin/"simutil").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_libexec("dart-sdk")}/bin/dartaotruntime" "#{libexec}/simutil.aot" "$@"
    SH
    chmod 0755, bin/"simutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/simutil version")
    output = shell_output("#{bin}/simutil invalid-command 2>&1", 255)
    assert_match 'Could not find a command named "invalid-command"', output
  end
end
