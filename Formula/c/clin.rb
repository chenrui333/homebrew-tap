class Clin < Formula
  desc "Terminal note management application"
  homepage "https://github.com/reekta92/clin-rs"
  url "https://github.com/reekta92/clin-rs/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "fd81830672741d7474c058876dec2e343fd1001bab9bed975342dc19480b66ef"
  license "GPL-3.0-only"
  head "https://github.com/reekta92/clin-rs.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clin --version")
    output = shell_output("#{bin}/clin --config #{testpath}/config.toml config show")
    assert_match (testpath/"config.toml").to_s, output
  end
end
