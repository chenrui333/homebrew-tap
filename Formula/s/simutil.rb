class Simutil < Formula
  desc "Manage mobile simulators and devices"
  homepage "https://github.com/dungngminh/simutil"
  url "https://github.com/dungngminh/simutil/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "110239660360c99ff31a4579fa07e2f18c538ba1e2068d8add9f9e43b1784710"
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

  deny_network_access!

  def fetch
    with_env(PUB_CACHE: HOMEBREW_CACHE/"simutil--pub") do
      system "dart", "pub", "get", "--enforce-lockfile"
    end
  end

  def install
    libexec.mkpath
    with_env(PUB_CACHE: HOMEBREW_CACHE/"simutil--pub") do
      system "dart", "compile", "aot-snapshot", "packages/simutil/bin/simutil.dart", "-o", libexec/"simutil.aot"
    end
    (bin/"simutil").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_libexec("dart-sdk")}/bin/dartaotruntime" "#{libexec}/simutil.aot" "$@"
    SH
    chmod 0755, bin/"simutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/simutil version")
    output = shell_output("#{bin}/simutil invalid-command 2>&1", 64)
    assert_match 'Could not find a command named "invalid-command"', output
  end
end
