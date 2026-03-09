class Countryfetch < Formula
  desc "Neofetch-like tool for fetching information about your country"
  homepage "https://github.com/nik-rev/countryfetch"
  url "https://github.com/nik-rev/countryfetch/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a41f2108ab81af92a4a5550f87409fd0291c710b640fb8edea06392f8b669c4e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/nik-rev/countryfetch.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    inreplace "Cargo.toml", 'openssl = { version = "0.10", features = ["vendored"] }', 'openssl = "0.10"'

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/countryfetch --version")

    output = shell_output("#{bin}/countryfetch --no-color --no-flag --no-palette Japan")
    assert_match "Japan", output
    assert_match "ISO Codes: JP / JPN", output
  end
end
