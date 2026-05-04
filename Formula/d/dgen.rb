class Dgen < Formula
  desc "Sega Genesis / Mega Drive emulator"
  homepage "https://dgen.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dgen/dgen/1.33/dgen-sdl-1.33.tar.gz"
  sha256 "99e2c06017c22873c77f88186ebcc09867244eb6e042c763bb094b02b8def61e"
  license all_of: ["BSD-3-Clause", "LGPL-2.0-or-later", "GPL-2.0-or-later"]

  head do
    url "https://git.code.sf.net/p/dgen/dgen.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libarchive"
  depends_on "sdl12-compat"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-sdltest
      --prefix=#{prefix}
    ]
    args << "--disable-asm" if Hardware::CPU.arm?
    system "./autogen.sh" if build.head?
    inreplace "main.cpp", '"DGen/SDL v"VER', '"DGen/SDL v" VER'
    inreplace "main.cpp", '"DGen/SDL version "VER', '"DGen/SDL version " VER'
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      If some keyboard inputs do not work, try modifying configuration:
        ~/.dgen/dgenrc
    EOS
  end

  test do
    assert_equal "DGen/SDL version #{version}", shell_output("#{bin}/dgen -v").chomp
  end
end
