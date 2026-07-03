class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.27.4.tar.gz"
  sha256 "d37874d356292f533f23529dcb0af45c98b6026f6faa2a1c54507bb63279674f"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e6fba8aec5a83c92228bdd352999be04718f543739da425bffa4376250979ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b33d9e355bd8e9d81002951cdddf48c3e96e1543241502a28910f3e0e5b3c551"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0662ba856d75ea04bf560fd6a5e0f28af32bfc66140991079e25acdbf3014359"
    sha256 cellar: :any,                 arm64_linux:   "ab9997a0f11cae765197352039e5d78d38b565ef43c2fee24ff9d2a5c79dcbb8"
    sha256 cellar: :any,                 x86_64_linux:  "127f92ea50bd23618890503a2d0535cd948099de2fed54e3d1b7ce2eeab97142"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdns-scanner --version")
    assert_match "# mdns-scanner configuration file", shell_output("#{bin}/mdns-scanner dump-default-config")
  end
end
