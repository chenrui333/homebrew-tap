class Tredis < Formula
  desc "Terminal UI for Redis servers"
  homepage "https://github.com/huseyinbabal/tredis"
  url "https://github.com/huseyinbabal/tredis/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "cabecaa55b0dce4162f88c27a4949102e53563a0cd0945116a6408d6f122b306"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05bf446f030331b0c7756f952729167ed66ec29066118578ef428a8acbf5caa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e39cefe1e31fbaa00ade80656c00e3b9c15a6e10c4056e32ef9ad8962c8d5527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13c5fc83d25e41220858eb3911a3e6ee87e66c52d303cd45e7d7b7d71c2aded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "427f717c3519c48904f91a196d5486bacc93f32b2167f1ec1628549178a66ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce66aaa530230664b63b736b7c6c248585264781b252925954906264737f4d64"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

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
