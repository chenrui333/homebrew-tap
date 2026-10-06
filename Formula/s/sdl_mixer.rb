class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"
  license "Zlib"

  livecheck do
    skip "legacy version"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7f7145d9f508cd558f7b9849bbc30fcbb5c749847ff67370fb4970319118bc79"
    sha256 cellar: :any, arm64_sequoia: "56b406996aa0bbb69ff4ab7c6a5e120f60a4ef46569fdfbe4b78e351ace89a75"
    sha256 cellar: :any, x86_64_linux:  "ebcd692f9e6aae84613b30b4df98551fe879a81695f8a70ef75b8d6be513dc37"
  end

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

  deny_network_access!

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    inreplace "SDL_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %w[
      --enable-music-ogg
      --enable-music-flac
      --disable-music-ogg-shared
      --disable-music-mod-shared
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    testpath.install resource("playwave")
    # Skip SDL_main.h so playwave keeps its own `main`: SDLmain's Cocoa event loop
    # never starts SDL_main in a headless sandboxed test and the test hangs.
    system ENV.cc, "playwave.c", "-D_SDL_main_h", "-I#{include}/SDL",
                   "-I#{formula_opt_include("sdl12-compat")}/SDL",
                   "-L#{lib}", "-lSDL_mixer",
                   "-L#{formula_opt_lib("sdl12-compat")}", "-lSDL",
                   "-o", "playwave"
    Utils.safe_popen_read({ "SDL_VIDEODRIVER" => "dummy", "SDL_AUDIODRIVER" => "disk" },
                          "./playwave", test_fixtures("test.wav"))
    assert_path_exists testpath/"sdlaudio.raw"
  end
end
