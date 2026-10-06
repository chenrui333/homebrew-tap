class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  license "Zlib"

  livecheck do
    skip "legacy version"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "ac440296794f99efbf57c89f19c3167c864317f4f252aac4900bf64fa99ee1ca"
    sha256 cellar: :any, arm64_sequoia: "063236761fb54e93350440eb0df45701a4d6fdf7e398e01c104ae61878ae4b53"
    sha256 cellar: :any, x86_64_linux:  "a49688818c69763b5eec690868e88b4271e61d97d2551b8da4071fff2035f588"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl12-compat"
  depends_on "webp"

  # Fix graphical glitching
  # https://github.com/Homebrew/homebrew-python/issues/281
  # https://trac.macports.org/ticket/37453
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/41996822/sdl_image/IMG_ImageIO.m.patch"
      sha256 "c43c5defe63b6f459325798e41fe3fdf0a2d32a6f4a57e76a056e752372d7b09"
    end
  end

  deny_network_access!

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    inreplace "SDL_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
                          "--disable-sdltest",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "SDL_image.h"
      #undef main

      int main(int argc, char *argv[]) {
        const SDL_version *v = IMG_Linked_Version();
        printf("SDL_image %d.%d.%d\\n", v->major, v->minor, v->patch);
        for (int i = 1; i < argc; i++) {
          SDL_Surface *s = IMG_Load(argv[i]);
          if (!s) {
            fprintf(stderr, "%s: %s\\n", argv[i], IMG_GetError());
            return 1;
          }
          printf("%dx%d\\n", s->w, s->h);
          SDL_FreeSurface(s);
        }
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/SDL", "-I#{formula_opt_include("sdl12-compat")}/SDL",
                   "-L#{lib}", "-lSDL_image", "-L#{formula_opt_lib("sdl12-compat")}", "-lSDL", "-o", "test"
    images = %w[test.png test.jpg test.tiff].map { |f| test_fixtures(f) }
    assert_equal "SDL_image #{version}\n8x8\n1x1\n1x1\n", shell_output("./test #{images.join(" ")}")
  end
end
