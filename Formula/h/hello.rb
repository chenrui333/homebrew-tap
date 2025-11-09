class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/gnu/hello/hello-2.12.2.tar.gz"
  sha256 "5a9a996dc292cc24dcf411cee87e92f6aae5b8d13bd9c6819b4c7a9dce0818ab"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f0cd8fe483a4ac694629da26ffed3d9c5c465439333a5d5828ac43a51cf83f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e90304b5272338e10f0af043cb5807f1b924c7482e741a447401646ffc9b0c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e05d945ed060eefc1795fe9872e91da32891462f4c2858df3d8d882d20c7a977"
    sha256 cellar: :any_skip_relocation, sequoia:       "97891c0a99f7d9f5fa259eee5cb60239db2e137d59487c4710a462884170e57d"
    sha256                               arm64_linux:   "138deb5732edb7d4aae310077fbe9e4a8b45864ed062509bb4d5f5919e06f77e"
    sha256                               x86_64_linux:  "d76742c95bde726045d0813335510cf2aebaeae36a44bdc0a0f246c827c6d7a7"
  end

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
