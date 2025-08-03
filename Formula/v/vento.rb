class Vento < Formula
  desc "Lightweight CLI Tool for File Transfer"
  homepage "https://github.com/kyotalab/vento"
  url "https://github.com/kyotalab/vento/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "493ca4d72c756ecc0773cfc2fca1731b03d4a3781107b2e32c2586c5c3600488"
  license "MIT"

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
