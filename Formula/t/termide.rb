class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide/archive/refs/tags/0.21.0.tar.gz"
  sha256 "acfc674dfd5affc08a47795b539ddb20d9907f2ea9a412c871a3e18f906a8891"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1a5444c15556c7eacc7d16a015df77fd947b3094e8e58a567072684f52f335e0"
    sha256                               arm64_sequoia: "21c01a83992381d4bbc518c4b81b05787fb6247bf6d46231bc3fd5c4ba814542"
    sha256                               arm64_sonoma:  "80ab6308a6188ebdd38c90fc2fa6517916c7f97a8ec88816b6ccfc15ea0965b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acc069a3dde5140c1f1ac29fdccb12465bdf18b97515674d555b79a3378aa5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7988bbaca4851e392aa91613c50ae4c70a3e81cccddf33ac0d874278fe417307"
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
  end
end
