class DealveTui < Formula
  desc "Terminal interface for game deal discovery"
  homepage "https://github.com/kurama/dealve-tui"
  url "https://github.com/kurama/dealve-tui/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "b7361e77437307ba967eba74afbdb771712160e5980b5f6d5dfb2deb624f2ad7"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]
    ENV["OPENSSL_DIR"] = openssl.opt_prefix
    ENV["OPENSSL_LIB_DIR"] = openssl.opt_lib
    ENV["OPENSSL_INCLUDE_DIR"] = openssl.opt_include
    ENV.prepend_path "PKG_CONFIG_PATH", openssl.opt_lib/"pkgconfig"
    system "cargo", "install", "--bin", "dealve", *std_cargo_args(path: "tui")
  end

  test do
    cmd = if OS.mac?
      "printf '\\033' | script -q /dev/null #{bin}/dealve"
    else
      "printf '\\033' | script -q -c '#{bin}/dealve' /dev/null"
    end
    output = shell_output(cmd)
    assert_match "\e[?1049h", output
  end
end
