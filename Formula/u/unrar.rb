class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-7.2.6.tar.gz"
  sha256 "d1afa67ef4121ebc5986815699e05db0ce8648499e5dca854f282a4c3f72c003"
  license "UnRAR"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6f33890fa020c402d9eefa3e63452dd5ee6814c914d4f3afc3187bb6fbece3fb"
    sha256 cellar: :any,                 arm64_sequoia: "c9b2c635fe4fcd0f594f9954c256c96d0def77ab2a4dde1bf94c42489e549994"
    sha256 cellar: :any,                 arm64_sonoma:  "ca60c09be4f5220c89a9c53fe05993b711f8a5181f384050867faddc7bfd7df4"
    sha256 cellar: :any,                 sequoia:       "189b1764dd88bbc522ce19a8710b6e00f71bdde9bb82bca188ad781e23dd3d03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d22645f9816d2e6476f5d60d80f35ae6eb76ec2963b083605253b443191cb2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d90ed7a97cedcf69cb5b31e0ad0c659b657ec58e3c5ee4e618554cc6e8e195"
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
