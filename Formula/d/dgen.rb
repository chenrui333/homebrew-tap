class Dgen < Formula
  desc "Sega Genesis / Mega Drive emulator"
  homepage "https://dgen.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dgen/dgen/1.33/dgen-sdl-1.33.tar.gz"
  sha256 "99e2c06017c22873c77f88186ebcc09867244eb6e042c763bb094b02b8def61e"
  license all_of: ["BSD-3-Clause", "LGPL-2.0-or-later", "GPL-2.0-or-later"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8dd287512a2b98448f61b94ccd3f0ac49dd49382ec5dc2b3b9b07322054a701"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406945a412c01d32c1e0426722159fbd51ab4d291a71a07598a4599b3f4f407d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54939e9a3ad43fb68c7627a93ce61a441912196fb3b9fddff5cdb83cb63db6fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9906018b434b4c10fb12cd165057759be64bf6e03572baa8a688ac97fd9803b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6037e60ecce43f013cf0a0098e4c810350549510e950d70b9f9da98f6cd76ce"
  end

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
