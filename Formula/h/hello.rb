class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz"
  sha256 "8d99142afd92576f30b0cd7cb42a8dc6809998bc5d607d88761f512e26c7db20"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde27ecd514ed05608167d92c9637ae160b5f61ac2e8ef7016570ee85efb84a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e76f821523eba33893c934a3948703723d2903663731ea79b5af4aceede782"
    sha256 cellar: :any_skip_relocation, ventura:       "c7b33da8268b818bb4b87a021cdc0b6a5882718547aabf7ee899eaed73aefc4f"
    sha256                               x86_64_linux:  "317ef881395e6bed73d1cee0cf3368bd7bd8d1ebaca9a5f0f5183bc5fda6860f"
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
