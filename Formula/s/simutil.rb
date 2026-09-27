class Simutil < Formula
  desc "Manage mobile simulators and devices"
  homepage "https://github.com/dungngminh/simutil"
  url "https://github.com/dungngminh/simutil/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e36443d8f8f42aded7f92f27ff34bdca0a3b7f674aac96f43c85c3a20f525254"
  license "MIT"
  head "https://github.com/dungngminh/simutil.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "fd19530cfccdf59067976115911643badf68c993c2e0fe4e55b7361594393eac"
    sha256                               arm64_sequoia: "64e7fca1f4c0c10392716111e7e863209bbe73c21b3d11bc0f4dbf46354b413a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2f9c18c370339c952169c026d3b247ec6b547516972a966d2adefe5a050537d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f26b12a06478a649376ed688fa3619809ad584a95036a89a3379ee331d82ef"
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
