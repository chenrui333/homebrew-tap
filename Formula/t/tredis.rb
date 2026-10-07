class Tredis < Formula
  desc "Terminal UI for Redis servers"
  homepage "https://github.com/huseyinbabal/tredis"
  url "https://github.com/huseyinbabal/tredis/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "cabecaa55b0dce4162f88c27a4949102e53563a0cd0945116a6408d6f122b306"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe838741552f5c6b56ec35de25640f6c7600c6097e3a53b72e897bb8030f8e4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa3ef92ab51c844f3511b9224be3ed94fb8e3da8375981165bae9b4cb3a7ebef"
    sha256 cellar: :any,                 arm64_linux:   "829bb1cff0502ce17ca0e3d6a3a9c5c3d2b04417167f50170e8e9ffe34a9bcc5"
    sha256 cellar: :any,                 x86_64_linux:  "ea7aa29c7366b28b83fafce606271845127b7f6e69caeadf59912903b5e0b908"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    openssl = Formula["openssl@3"]
    ENV["OPENSSL_DIR"] = openssl.opt_prefix
    ENV["OPENSSL_LIB_DIR"] = openssl.opt_lib
    ENV["OPENSSL_INCLUDE_DIR"] = openssl.opt_include
    ENV.prepend_path "PKG_CONFIG_PATH", openssl.opt_lib/"pkgconfig"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tredis --version")

    output = shell_output("#{bin}/tredis --log-level nonsense 2>&1", 2)
    assert_match "invalid value 'nonsense' for '--log-level <LOG_LEVEL>'", output
    assert_match "possible values: off, error, warn, info, debug", output
  end
end
