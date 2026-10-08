class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.40.0",
      revision: "0719f56e39f6eee4119f53fe40167c4344083fde"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7b93a0021f5c8b2387c1510316852c7cc70e86605847e8eb141a3e841224528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9daa6e8eb4a77efc5642e76d4c3c0b7f57ee8da86dc7950455fc7d83539f5112"
    sha256 cellar: :any,                 arm64_linux:   "e0e8df2a152126aed80204cf93544d11312ba347cab67f426b5c1598045e8a5e"
    sha256 cellar: :any,                 x86_64_linux:  "619e276e0a136369d341a40822d7fccffba0f180d941e13dd23c9c89c35a7f87"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")

    output = shell_output("#{bin}/termide --config #{testpath}/missing.toml --diagnostics 2>&1", 1)
    assert_match "load: No such file or directory", output
    assert_match "One or more checks failed", output
  end
end
