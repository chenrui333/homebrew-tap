class DealveTui < Formula
  desc "Terminal interface for game deal discovery"
  homepage "https://github.com/kurama/dealve-tui"
  url "https://github.com/kurama/dealve-tui/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "b7361e77437307ba967eba74afbdb771712160e5980b5f6d5dfb2deb624f2ad7"
  license any_of: ["MIT", "Apache-2.0"]
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "917519a7fa63532d426624fe4154380fe6abf79187f1617fe5ff0936114db224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2350e5546000070d6ef25a97bda5bc9c6922820c603aaa98fc3939e2b8a85dfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5caace23e7966575906929118684b34bd5ac6778387ebe6c5453cfd56125eae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eb31523e97a8d89fea0a357a6a597a3f58ec8267d83abb35229a8ebd6226cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63175a7ce7094b8f5d9cd525800008ed0253a0b95e8ca2e304642caa135762ad"
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
