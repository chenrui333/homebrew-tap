class Simutil < Formula
  desc "Manage mobile simulators and devices"
  homepage "https://github.com/dungngminh/simutil"
  url "https://github.com/dungngminh/simutil/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "7fe9b4a287f8f9827af8c68a91f4ceafb5f0758260d418cca0e628fc862c823a"
  license "MIT"
  head "https://github.com/dungngminh/simutil.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "fe6991db8040f6088265fc169bb156814e5f9ac5c2c5afdb6dd61d31731381d7"
    sha256                               arm64_sequoia: "c4a3d1b0d2b2dcd27160b59baf92f42ed0afca05acad5a7d7f7efecd2cdf85a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1134c644ce8bfe823788c4367ffb2411b3bf4b1a43d9b4099853d796894aaf85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bface47e63b3b128d298053057477b5e4a9b20ab623f43a2190c72099882c480"
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
