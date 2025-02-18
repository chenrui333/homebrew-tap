class Ip2d < Formula
  desc "Converter for IP addresses"
  homepage "https://github.com/0xflotus/ip2d-rust"
  url "https://github.com/0xflotus/ip2d-rust/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e6d0d5401729b23f16bb23eaf6d9a590bbfd562404b621b61275208d4ad2f8e7"
  license "MIT"
  head "https://github.com/0xflotus/ip2d-rust.git", branch: "main"

  depends_on "rust" => :build

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
