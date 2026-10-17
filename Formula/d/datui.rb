class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "ed55190704f5cd0199c9892d29ff31c75b041245cd9e43a71a71749d641788bd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8507ff9796fa0700f600552c4670cf7a66166e3721114a8ff1c96c468e15281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1928082a66e35aaa7f80b6b987ba81273af37d26444f163812e8c769d2b852a"
    sha256 cellar: :any,                 arm64_linux:   "2533d92c49a0bef934343d2d364b33e952e337839d521b6aa1846b72a29347dd"
    sha256 cellar: :any,                 x86_64_linux:  "9f2cfb504ad1539548b647cda62481c7d607e4414075e95128501b50088f71ae"
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
