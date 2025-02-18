class Ip2d < Formula
  desc "Converter for IP addresses"
  homepage "https://github.com/0xflotus/ip2d-rust"
  url "https://github.com/0xflotus/ip2d-rust/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e6d0d5401729b23f16bb23eaf6d9a590bbfd562404b621b61275208d4ad2f8e7"
  license "MIT"
  head "https://github.com/0xflotus/ip2d-rust.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80803223ecfd3e79dd9bd409a78b1e20389d9cbfadf2176564dc41837a940aab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e9870f333c24f2b5543f436ba888adca6eeea44e5b1b67b1831b30fdc8d3ad3"
    sha256 cellar: :any_skip_relocation, ventura:       "5169ab4314f78bb44772ae4d3aa749e1bea80e44b29d104283600bde7bcdf073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a052a5d308e058726b6cfb09bb457bfa3d55386b9441ed24f01f5d0827385e"
  end

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
