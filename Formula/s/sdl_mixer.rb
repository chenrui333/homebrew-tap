class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/release-1.2.html"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"
  license "Zlib"

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "libmikmod"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl12-compat"

  # Source file for sdl_mixer example
  resource "playwave" do
    url "https://github.com/libsdl-org/SDL_mixer/raw/1a14d94ed4271e45435ecb5512d61792e1a42932/playwave.c"
    sha256 "92f686d313f603f3b58431ec1a3a6bf29a36e5f792fb78417ac3d5d5a72b76c9"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    inreplace "SDL_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-music-ogg
      --enable-music-flac
      --disable-music-ogg-shared
      --disable-music-mod-shared
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    testpath.install resource("playwave")
    cocoa = []
    cocoa << "-Wl,-framework,Cocoa" if OS.mac?
    system ENV.cc, "playwave.c", *cocoa, "-I#{include}/SDL",
                   "-I#{Formula["sdl12-compat"].opt_include}/SDL",
                   "-L#{lib}", "-lSDL_mixer",
                   "-L#{Formula["sdl12-compat"].lib}", "-lSDLmain", "-lSDL",
                   "-o", "playwave"
    Utils.safe_popen_read({ "SDL_VIDEODRIVER" => "dummy", "SDL_AUDIODRIVER" => "disk" },
                          "./playwave", test_fixtures("test.wav"))
    assert_predicate testpath/"sdlaudio.raw", :exist?
  end
end
