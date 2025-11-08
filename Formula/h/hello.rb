class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/gnu/hello/hello-2.12.2.tar.gz"
  sha256 "5a9a996dc292cc24dcf411cee87e92f6aae5b8d13bd9c6819b4c7a9dce0818ab"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e36b8a4679ef2d716cd6885d1a5b6c6b3e69d8fc73d40f5dfc3ff388ebd434c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d07283f1458cd1652c313f48b27048ee751613384dc5713141633420e37aead8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf9dcfadce578bf10d36e584127c67e0487029f55404bab35c0e046f8dd708cf"
    sha256 cellar: :any_skip_relocation, sequoia:       "0a435b345e474e31250ab2668600e55cbf70a960694afcb5be20b20aa8ac479e"
    sha256                               arm64_linux:   "c60b1abb7173841909f40f4ce6e35ec5df90e441a897e989606a4170d1bbf554"
    sha256                               x86_64_linux:  "621ebc7ccb721b0eeda4aeb1c61c79bfd6080ad623bcd9ce8139895c2722e6d8"
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
