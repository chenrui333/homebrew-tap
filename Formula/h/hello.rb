class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/gnu/hello/hello-2.12.3.tar.gz"
  sha256 "0d5f60154382fee10b114a1c34e785d8b1f492073ae2d3a6f7b147687b366aa0"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8442cfcdba8a8feedfcaf52dce350fda6be1488f9ce335da7b14e6c158df37e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67790351528ade5aaec9dd06a75ba9249084abbfd411ccdb77c6248647dc0a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37476d15434fb91ded76e65afe0c6a35d8d5625ca71fe46fb1da87c90ebac215"
    sha256 cellar: :any_skip_relocation, sequoia:       "21e0af6ebde9a23c5c276a4b53902c3da7f1de7dc1faf7bf4f1a9f4618117ded"
    sha256                               arm64_linux:   "e737a08e027323506cb0a4937c8271479b425f25ef0675ba1f9e1bb16f5c7af6"
    sha256                               x86_64_linux:  "ccce0d2698ee0db5425be6cc8ad5b888560b0ba1b3191592351d6e092502547c"
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
