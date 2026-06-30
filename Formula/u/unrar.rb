class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-7.2.7.tar.gz"
  sha256 "01d903a7dcf413cb2925696d7796e48e38d471f79bfe7ef3ad2aebf6c12dbefd"
  license "UnRAR"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "5edf0ed5f3f296c9f8f74b7e367a78c21e28b42807d13ad93176dbf524e83b90"
    sha256 cellar: :any, arm64_sequoia: "e5afd0625c7e5942a4cbf7f5eab34b931bfaf9a530c105e49a848bd374157f38"
    sha256 cellar: :any, arm64_sonoma:  "e3b05707414f3bdb25c9cfb7323e518908fb828bfee8f64681c6caf9519ae527"
    sha256 cellar: :any, sequoia:       "b0ae5368a726420f43acea4b716d194786281833cb8ac000a52bfc1853f9fb99"
    sha256 cellar: :any, arm64_linux:   "1103cc1f66e3802fb7f7f62715e0d21d6bebf55de7f24379057a87adf6dbeb89"
    sha256 cellar: :any, x86_64_linux:  "5ff0630d52cbe4da4e4e8a3c142ada58cbf8c750eaec8da64691b30749d8e581"
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
