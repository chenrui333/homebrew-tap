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
    sha256 cellar: :any,                 arm64_sequoia: "275c8cb391aee2df3485a71ad6a548556d7b8b36e67990e99a17c06a92bcc68f"
    sha256 cellar: :any,                 arm64_sonoma:  "9a8238ea96341faa72a345ae7a2fc36c2126ac6e354b995ec70a496d0e9c5778"
    sha256 cellar: :any,                 ventura:       "7ac23ffb3ce5703d7109f60e4ceb2660b95cbad136431952682f569be7c07c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e284106de4b98bb7ee9a54e2ded32c4c92db520c4b358fd8cbb261b86b1b891"
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
    cocoa = []
    cocoa << "-Wl,-framework,Cocoa" if OS.mac?
    system ENV.cc, "playwave.c", *cocoa, "-I#{include}/SDL",
                   "-I#{Formula["sdl12-compat"].opt_include}/SDL",
                   "-L#{lib}", "-lSDL_mixer",
                   "-L#{Formula["sdl12-compat"].lib}", "-lSDLmain", "-lSDL",
                   "-o", "playwave"
    Utils.safe_popen_read({ "SDL_VIDEODRIVER" => "dummy", "SDL_AUDIODRIVER" => "disk" },
                          "./playwave", test_fixtures("test.wav"))
    assert_path_exists testpath/"sdlaudio.raw"
  end
end
