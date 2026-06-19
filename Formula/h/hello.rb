class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/gnu/hello/hello-2.12.3.tar.gz"
  sha256 "0d5f60154382fee10b114a1c34e785d8b1f492073ae2d3a6f7b147687b366aa0"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c50cebcea7f28a3d731c763ab2ebc89971aa2e6a7a5c003cf537ff7b5a699949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a34c7dd5e7e44e6305073921a562d39661989be208f4d9f30f7cad13f564b04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffe7a2e1e847d27e9605bfb67774ff2d1d0c2a6903f0ebbbfd4e78c619a744db"
    sha256 cellar: :any_skip_relocation, sequoia:       "f0fff8bb41c131a63a1a3ef88c765e8582c0dc25ee44f1cd402c90bf4881f195"
    sha256                               arm64_linux:   "5fcd4c8440df4124e32f221b3e0d6ca33db4815802d5713853a4b1c3eb6d5f58"
    sha256                               x86_64_linux:  "6069f4a013535ca6e8c5b47239f14805f791dceafa5bba48440ae5357d339fdf"
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
