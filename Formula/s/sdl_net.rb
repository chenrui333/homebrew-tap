class SdlNet < Formula
  desc "Sample cross-platform networking library"
  homepage "https://github.com/libsdl-org/SDL_net"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.8.tar.gz"
  sha256 "5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4"
  license "Zlib"

  livecheck do
    skip "legacy version"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "6290cb3a2ab8ca9379e43443250c7f323f286804eac389b5d1decca81d22c2b3"
    sha256 cellar: :any,                 arm64_sonoma:  "ff31cf3b4532d9a4de50892b2738aa788bedad8bca71e6f55f2914461d4ea184"
    sha256 cellar: :any,                 ventura:       "f26f218b290b37b0b13d94ebe5a004c2c4f2890ae7881b57f7349c3980f098b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1acfdfa46899600bcc0ce4d57a6a74c821766155af44a3cee7bdf48e34b539f4"
  end

  depends_on "pkgconf" => :build
  depends_on "sdl12-compat"

  def install
    system "./configure", "--disable-sdltest", *std_configure_args
    system "make", "install"
  end
end
