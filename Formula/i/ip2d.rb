class Ip2d < Formula
  desc "Converter for IP addresses"
  homepage "https://github.com/0xflotus/ip2d-rust"
  url "https://github.com/0xflotus/ip2d-rust/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e6d0d5401729b23f16bb23eaf6d9a590bbfd562404b621b61275208d4ad2f8e7"
  license "MIT"
  head "https://github.com/0xflotus/ip2d-rust.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a3a4e7767d4e0982e51332c24418ba438bffbe8656ac531a6d20209e48806fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52bdda69350d645a6d1dc41dac889a708eb93ec23075c2efa3b9a450605bc3db"
    sha256 cellar: :any,                 arm64_linux:   "9c486097354d0e6b4541a06aec613d475387d5604c0d8157c590543a147f00d4"
    sha256 cellar: :any,                 x86_64_linux:  "d96ac3c046a45471faabd893e19b7fe9a1366f73f2ba9fe557b046c245d72a63"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # version patch
    inreplace "src/main.rs", ".version(\"0.5.0\")", ".version(env!(\"CARGO_PKG_VERSION\"))"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ip2d --version")

    output = shell_output("#{bin}/ip2d 192.168.0.1")
    assert_equal "3232235521", output.chomp
  end
end
