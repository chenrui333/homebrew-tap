class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-6.0.2.tar.gz"
  sha256 "81bf188333f89c976780a477af27f651f54aa7da9312303d8d1a804696d3edd3"
  license "UnRAR"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9d62e765e7e4e0c8e8f96bd9aaba72f83ee394cddc70cb5ae2e489e941806fb8"
    sha256 cellar: :any,                 arm64_sequoia: "c9418a200e643737d27d2545c869ccdc6452a5f995fc34e3e2855180739ef8d4"
    sha256 cellar: :any,                 arm64_sonoma:  "f83a269042439e5bb1fbceb45ac55941798892429c614d6b151c8ff78e261997"
    sha256 cellar: :any,                 sequoia:       "c0b3466e937f7a09d0e16c4b1f9e557923458845870afee60063956de662e8df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5de99403b07b99e6dbdac2653d0d5cd2e8cfbe4e71458c41864402e30732db75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7ab2fd9551471f591e47e8050a6568023f1b2e6cc80e8358d3b9ff1fa23cdb"
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
