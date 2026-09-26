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
    sha256 cellar: :any, arm64_tahoe:   "a6f092793575584bdc8f5cab09725d6972f88f9af5142664c9fa55dfcafb2d90"
    sha256 cellar: :any, arm64_sequoia: "0e735b2a77c151b051e44a4646d2a7d5c06512e2b3c426835cb9b04c85b2b37a"
    sha256 cellar: :any, arm64_linux:   "8c112d4b8d36636151e7f5dc23e7e3494e0403cdfd3493e5022315205313e3b5"
    sha256 cellar: :any, x86_64_linux:  "793cec0df015e1d171eff5b563d0f3eb246629cacdfb4b8a7a594441b7b4f425"
  end

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
