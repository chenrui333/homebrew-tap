class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz"
  sha256 "8d99142afd92576f30b0cd7cb42a8dc6809998bc5d607d88761f512e26c7db20"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/chenrui333/homebrew-tap/releases/download/hello-2.12.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0db12a13adbad7018abfbcf46196d2e6b5868c7cf202fda4b15c99226213a266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af912d03c2df4d3d4dc2a2d8c3f4949376df384b62f2aba7c5274c96a99ad87"
    sha256 cellar: :any_skip_relocation, ventura:       "e28334920a797a5c7aff2a86f0dcf10b56bae30d3220fe86f47e95c5cf68c2a7"
    sha256                               x86_64_linux:  "e1eb39d36eeadb4d58b2d665a87de726ab628cdf27a0e6aeba7b84063daa95f1"
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
