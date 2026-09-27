class Simutil < Formula
  desc "Manage mobile simulators and devices"
  homepage "https://github.com/dungngminh/simutil"
  url "https://github.com/dungngminh/simutil/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e36443d8f8f42aded7f92f27ff34bdca0a3b7f674aac96f43c85c3a20f525254"
  license "MIT"
  head "https://github.com/dungngminh/simutil.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "98b9b76b77bf1d010de762819346b15ddf0d2ddef780747610a440ca7e17547a"
    sha256                               arm64_sequoia: "76ce1836e91678a9ddacf8fdac79b575104ce258309dc7e65bd4af955bbb569c"
    sha256                               arm64_sonoma:  "7e0f957cd751f1b82bbea635e8c7aef4e27c00f648643bcf63cb2f280cddc2a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc13b56179833d1c19df39742ee9009184acb0fd8a740b9ee155846480cc45f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9836af18fa9c98cbe37e86a7cd583f76f900bb8f7a6f9d7aae0a94b97812cc43"
  end

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
