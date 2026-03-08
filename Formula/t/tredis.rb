class Tredis < Formula
  desc "Terminal UI for Redis servers"
  homepage "https://github.com/huseyinbabal/tredis"
  url "https://github.com/huseyinbabal/tredis/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "cabecaa55b0dce4162f88c27a4949102e53563a0cd0945116a6408d6f122b306"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]
    ENV["OPENSSL_DIR"] = openssl.opt_prefix
    ENV["OPENSSL_LIB_DIR"] = openssl.opt_lib
    ENV["OPENSSL_INCLUDE_DIR"] = openssl.opt_include
    ENV.prepend_path "PKG_CONFIG_PATH", openssl.opt_lib/"pkgconfig"

    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tredis --version")

    output = shell_output("#{bin}/tredis --log-level nonsense 2>&1", 2)
    assert_match "invalid value 'nonsense' for '--log-level <LOG_LEVEL>'", output
    assert_match "possible values: off, error, warn, info, debug", output
  end
end
