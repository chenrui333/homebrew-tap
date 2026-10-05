class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "09bc30c592f077010418359e6e04b2837e1fb776f694eff196d2dd4e7e7f0dfc"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8854a1094d9341f843c169f9507ef9e395cc720455ea8d585b396fd1638beb8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bf8f20b0f1415a884058ae7a2e6a77da82e6dcb9b0d4883ef46d8ef0a46f2e6"
    sha256 cellar: :any,                 arm64_linux:   "59c9a395ec7bfb74c6d18ba53e1853b2a4d51e16021ac0decbdf94e0e984c244"
    sha256 cellar: :any,                 x86_64_linux:  "b971086029faaefa1979e5c58626ed494f7d667b011d391ccf4a0a5895cae2a1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdns-scanner --version")
    assert_match "# mdns-scanner configuration file", shell_output("#{bin}/mdns-scanner dump-default-config")
  end
end
