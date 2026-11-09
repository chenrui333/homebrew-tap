class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/hello/hello-2.12.3.tar.gz"
  sha256 "0d5f60154382fee10b114a1c34e785d8b1f492073ae2d3a6f7b147687b366aa0"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "031627c6725d575d9c73287c57d21d6cc5d17da54275a3efe54c9ea6649e614d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4288fcf9a7709a643d049cac122417b4cde2b77c042b1a921060b6cdf253d66"
    sha256                               arm64_linux:   "e2973d15c7281c1152ce70aa2666123857b761180de85c8e018333cedcb5f5a7"
    sha256                               x86_64_linux:  "845e56d0496dd44cb24dbf43512b915e3e0f8e68d0b7f608c9d3c58ecd9f7f9e"
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
