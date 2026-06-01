class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.3",
      revision: "10aeabfc024332fb2496b632d380ccedae2597ee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54dde2ff2147695889406a89e8ae3c25bba628c61506748b176a3fb65c9ad46e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d35b117a9f5a36ec8d483a1a482289283fd7c04ca5bfb9bbbc59566c213ae6b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc518f9f0d15752f6f03df808092ea1d7ef84ef995d7f17941e4bb207bfb2be5"
    sha256 cellar: :any,                 arm64_linux:   "89dcf8b98a042af84c2347c36e0feb5e2eb04b925cefad1f1ea44cfd9e5ca7d0"
    sha256 cellar: :any,                 x86_64_linux:  "887fa3f501e36470134e9c772c3788234819569e867d23ed6e66ca964ab9756c"
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
