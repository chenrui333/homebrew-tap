class Simutil < Formula
  desc "Manage mobile simulators and devices"
  homepage "https://github.com/dungngminh/simutil"
  url "https://github.com/dungngminh/simutil/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "7fe9b4a287f8f9827af8c68a91f4ceafb5f0758260d418cca0e628fc862c823a"
  license "MIT"
  head "https://github.com/dungngminh/simutil.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "d95a81f590f4406c5fb81435a5925383ef8a3d89f4a5a2ecaef9dc5f8a44e247"
    sha256                               arm64_sequoia: "901ef4ee3984ecc8ded07204a90cfa23229dd550659ba5dae02ef2aa66fc547e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e6e5df9c1af4429715c7253042f9c35d4cfafe656fcd3297fae3a812de4813a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f032aba194aeb91dc4ab14146b145996972259cc2f79f85a474d322c463089"
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
