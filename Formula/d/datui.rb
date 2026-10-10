class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "bfa19edbcf1ba3479a28f6bf996f9653485fd65e430866ba034a752cac7980e3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c5b877cf8ec9faba600f80e6ad30790b8406223c605d342b532f12eb8dfed69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bbb8e548d88d6b76ad9ff6b75cd31f020d2fedd7b22a62191cc17ad8a0ded9d"
    sha256 cellar: :any,                 arm64_linux:   "d7e9435f403c685e7a142433f5a68ea9f09c898a958820b279860ed22af5c61c"
    sha256 cellar: :any,                 x86_64_linux:  "1b21a2c71f047fe2f190b6c81748738ca2381917e0ffdf49008fc037c2940018"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui config init")
    assert_match(/Wrote .*config\.toml/, output)
  end
end
