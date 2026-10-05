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

  deny_network_access!

  def install
    system "./configure", "--disable-sdltest", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "SDL_net.h"
      #undef main

      int main(void) {
        const SDL_version *v = SDLNet_Linked_Version();
        printf("SDL_net %d.%d.%d\\n", v->major, v->minor, v->patch);
        if (SDLNet_Init() != 0) {
          fprintf(stderr, "SDLNet_Init: %s\\n", SDLNet_GetError());
          return 1;
        }
        IPaddress ip;
        if (SDLNet_ResolveHost(&ip, NULL, 4242) != 0) return 1;
        printf("%u\\n", SDLNet_Read16(&ip.port));
        SDLNet_Quit();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/SDL", "-I#{formula_opt_include("sdl12-compat")}/SDL",
                   "-L#{lib}", "-lSDL_net", "-L#{formula_opt_lib("sdl12-compat")}", "-lSDL", "-o", "test"
    assert_equal "SDL_net #{version}\n4242\n", shell_output("./test")
  end
end
