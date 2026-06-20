class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.25.0",
      revision: "4ab3eaf1fbff706932d34edde2d578ade8dec549"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbfe25745397069bab615ce22696f3d9553a3388da828d37cbb455d561a31620"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90cbb12815afc066b5ac1c5853fd753a8863fe7911b1b731a42096c9c5f591ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "546e399b6bf97fed85889539e11db354db248236e59dd20f29685730ff38adba"
    sha256 cellar: :any,                 arm64_linux:   "e4d52aff8dcd8082080fcb1b26dfacde669fe10d4a540d17bbd27d766b37383b"
    sha256 cellar: :any,                 x86_64_linux:  "a82dead92da65556cb9781b7f314752d32cfcac025274abdeb9a0449447b911b"
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
