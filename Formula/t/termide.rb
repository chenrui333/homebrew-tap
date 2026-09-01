class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.31.0",
      revision: "d67f14fa3386ef3ad3dc76b347117189bae51ebe"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47ee5d0b226dba4d1a850f82d4031cef2b1e234f96e34c7ff51d9639ea73ecec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f925c9fe969caa695e52511fb67f7de58962560ca173190659b0a413015fe690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeed0e121044a11bdeead36044790f1590f578424b94931574f133cc776a8af1"
    sha256 cellar: :any,                 arm64_linux:   "292200745c9c9ec516a64d6ff1f187c99695ef08b6479fb264697934b88d7527"
    sha256 cellar: :any,                 x86_64_linux:  "1a2c530207566a46c1b27a38e472a68809e3781746b592e858aa639ceef328b6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
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
