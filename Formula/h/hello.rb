class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/gnu/hello/hello-2.12.2.tar.gz"
  sha256 "5a9a996dc292cc24dcf411cee87e92f6aae5b8d13bd9c6819b4c7a9dce0818ab"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6b2b5f2873475045a47632fbee2cb76779567457d654b78900b57700d48d5f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d95e1acbb0ecf3a5ce5f2f7f4eea2eef482779faded5769b4caa6682934bfc95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "344c7911711052d344d00a4694801430a61d16c8f88bb9ce6501b6bda3fe8927"
    sha256 cellar: :any_skip_relocation, sequoia:       "3612597f201149e81fd079cf0bf0b8edda0fec1d0ca429bdf0d040d397fde304"
    sha256                               arm64_linux:   "18e1c66df070b89a338200ffd212eacb416eef1956a9943e834fd913091dfe83"
    sha256                               x86_64_linux:  "6db5b4fa760fb87b88b98022e0e1404d13808c60c88ab4877cbbd43ec59bec9d"
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
