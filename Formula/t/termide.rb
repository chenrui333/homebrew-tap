class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide/archive/refs/tags/0.21.0.tar.gz"
  sha256 "acfc674dfd5affc08a47795b539ddb20d9907f2ea9a412c871a3e18f906a8891"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "168359dac0b9f0fb5a6b195562061059bf285d50f56b19a0ab75d706e5304270"
    sha256                               arm64_sequoia: "67187c24a92f0737ee7a0db45a1d1e9307c5a5aaa32da592f071d8b769900863"
    sha256                               arm64_sonoma:  "fdeeb57d87b9c5f8ed968234216b5fa4d34dfefd63b7362afcded18cc2c75d2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad7c6b88634934731f9c74ee7abafbd164cac84d92f2e4b1848aa63cc316081c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8fe09cc9ba110d67fc55fb51aaccb0b4cfa0ee5293a483dc9ffe21ca05b1992"
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
