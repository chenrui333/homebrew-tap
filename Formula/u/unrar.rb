class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-7.3.2.tar.gz"
  sha256 "f61a1160d6e2ebbda2ad353c8e82f62ab4312f97fde23c6c2c982d25e0014f99"
  license "UnRAR"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "257715d84582ef10b6b1e547a21044b03fcf6fcb5b439e95fabaaa37187ea36f"
    sha256 cellar: :any, arm64_sequoia: "51e444b6f88714f1bcaf1cb49edcd7050d844e3ebdc4b6348892ec669b0dcefe"
    sha256 cellar: :any, arm64_linux:   "b6de4e762117d5eae652a43dcd6622c3d47904b655a61700cffa7ca6207eff94"
    sha256 cellar: :any, x86_64_linux:  "4dee5d9bfe9023161e85a5c4dad1440c0db30f1166b6a6e25e094a3712260c86"
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
