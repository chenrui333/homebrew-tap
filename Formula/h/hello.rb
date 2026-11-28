class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/hello/hello-2.12.3.tar.gz"
  sha256 "0d5f60154382fee10b114a1c34e785d8b1f492073ae2d3a6f7b147687b366aa0"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "56b173274f325e6770d7707250cf4755edbc03b885c7a3fa57e1e04ee0a2f504"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "434b4f02d224c8bcaeca3f9fbb3df0d9bc5ec47056f8fbf834907581f21a489b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2f15e7b19ad6ebd39d44453d6da94b203723335a11a710430395ade7dd8a5c3"
    sha256                               arm64_linux:   "cb5a554863588337c87dc4c7846a2332504e7a3537a89b595554c0f0767bb32f"
    sha256                               x86_64_linux:  "dc2d8efc6e2f412a7f695c3f5815d369c2ab017b08e9b45bfb9daa6cd2d520b1"
  end

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
