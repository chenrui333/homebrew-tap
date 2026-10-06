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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "af133def1163478dfc112ba345d9aa8aaaece9dfdae449189b2def3b8070f31e"
    sha256 cellar: :any, arm64_sequoia: "bc53800ebe64702051cbd6c7b99b139eff892a881748a56f8bc6012583a4d763"
    sha256 cellar: :any, x86_64_linux:  "bdf3e96432362ac86d74313abe1d2299b300a38cda96ce0c8505050f02a88a62"
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
