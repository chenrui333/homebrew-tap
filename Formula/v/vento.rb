class Vento < Formula
  desc "Lightweight CLI Tool for File Transfer"
  homepage "https://github.com/kyotalab/vento"
  url "https://github.com/kyotalab/vento/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "493ca4d72c756ecc0773cfc2fca1731b03d4a3781107b2e32c2586c5c3600488"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "5807509d561894e8bf11910d6a107d444d941ed4b3cf041e44a432005b705f4c"
    sha256 cellar: :any,                 arm64_sonoma:  "6a9eea8772c707589aca50e90f78a80097b1df4d067940f7a5f559a921737d7c"
    sha256 cellar: :any,                 ventura:       "d2b5d125edc1b89b228f9ea15307959582a21db73203edc0b54f81bdfa3acbbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f97c91f24c4242d79ea359098fc0d8d70fee2026a33351a6f7f0e1de8ce11f17"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vento --version")

    output = shell_output("#{bin}/vento admin 2>&1", 1)
    assert_match "Error: Failed to load default application configuration", output
  end
end
