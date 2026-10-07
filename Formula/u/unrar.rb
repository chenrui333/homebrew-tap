class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-7.3.1.tar.gz"
  sha256 "634900842a3737d9cc15bbcc71d4c74cc713437e0bca296a573424fe5f2660ab"
  license "UnRAR"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "8153e694216a1d74af39d80f75cc11d93b02c8dc290e5a166ec0b77bd1603e86"
    sha256 cellar: :any, arm64_sequoia: "38595c61e59cbd4afd5106fd9430395edc1097d093f7d9b1d1ea89af796d5312"
    sha256 cellar: :any, arm64_linux:   "85d9b16d757bd8fdde66ccefe2385ff730a14c5a354357f3e6e30c77914f1686"
    sha256 cellar: :any, x86_64_linux:  "889e98e1625a1817826be95feb535c9b6bd9ef83271824a568d732dc8b8ea710"
  end

  deny_network_access!

  def install
    inreplace "makefile", "libunrar.so", "libunrar.dylib" if OS.mac?

    system "make"
    bin.install "unrar"

    # Explicitly clean up for the library build to avoid an issue with an
    # apparent implicit clean which confuses the dependencies.
    system "make", "clean"
    system "make", "lib"
    lib.install shared_library("libunrar")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    contentpath = "directory/file.txt"
    rarpath = testpath/"archive.rar"
    data = [
      "UmFyIRoHAM+QcwAADQAAAAAAAACaCHQggDIACQAAAAkAAAADtPej1LZwZE",
      # spellchecker:ignore-next-line
      "QUMBIApIEAAGRpcmVjdG9yeVxmaWxlLnR4dEhvbWVicmV3CsQ9ewBABwA=",
    ].join

    rarpath.write data.unpack1("m")
    assert_equal contentpath, shell_output("#{bin}/unrar lb #{rarpath}").strip

    system bin/"unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
