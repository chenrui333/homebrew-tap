class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz"
  sha256 "8d99142afd92576f30b0cd7cb42a8dc6809998bc5d607d88761f512e26c7db20"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74d64c261b96e420941288d5544d61b09ea7ecc57ee2a8407e8a33b29ee1af8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "637b1501231f7b87fc57c702c1d71b2d05164497c97234009c759d29215b8e12"
    sha256 cellar: :any_skip_relocation, ventura:       "06c3f733cf558c777668187e474ca623a9f78a676b9dc01937bdfb3eb3fb6cef"
    sha256                               x86_64_linux:  "f7ef8c930676eb016c3dfca282b827def727f4753e794d31e89aa68f356ee859"
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
