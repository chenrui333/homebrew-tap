class SdlTtf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
  sha256 "724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7"
  license "Zlib"

  livecheck do
    skip "legacy version"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "80f35b9f7f08bb554baf5b1b52e6f2051e03bdfeab4dcf911a6754ea92af32fe"
    sha256 cellar: :any,                 arm64_sonoma:  "ead83ae3af0259d1e3d7adbd3f4da0e75eb9abd5db2982fdaa591f78940ee747"
    sha256 cellar: :any,                 ventura:       "98fd86e383c9b47b1ae397a92c5b1d5c5baae809e0328648e239a9f72ea28155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f3182d853fe5bf1ffc1d52bdc636da77420db2c1b09f0f3ab80808fa903db78"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "sdl12-compat"

  # Fix broken TTF_RenderGlyph_Shaded()
  # https://bugzilla.libsdl.org/show_bug.cgi?id=1433
  patch do
    url "https://gist.githubusercontent.com/tomyun/a8d2193b6e18218217c4/raw/8292c48e751c6a9939db89553d01445d801420dd/sdl_ttf-fix-1433.diff"
    sha256 "4c2e38bb764a23bc48ae917b3abf60afa0dc67f8700e7682901bf9b03c15be5f"
  end

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    inreplace "SDL_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-sdltest", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "SDL_ttf.h"
      #undef main

      int main(void) {
        const SDL_version *v = TTF_Linked_Version();
        printf("SDL_ttf %d.%d.%d\\n", v->major, v->minor, v->patch);
        if (TTF_Init() != 0) {
          fprintf(stderr, "TTF_Init: %s\\n", TTF_GetError());
          return 1;
        }
        if (TTF_OpenFont("missing.ttf", 12) != NULL) return 1;
        TTF_Quit();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/SDL", "-I#{formula_opt_include("sdl12-compat")}/SDL",
                   "-L#{lib}", "-lSDL_ttf", "-L#{formula_opt_lib("sdl12-compat")}", "-lSDL", "-o", "test"
    assert_equal "SDL_ttf #{version}\n", shell_output("./test")
  end
end
