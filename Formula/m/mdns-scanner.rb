class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "7ffef121085ad496751022d09a210bf50f10592d6886417821428942e494b49d"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4dbc3fd27fd15ba7f3912e5ce872a97d4e5fe19b48cba57cee81428627e990d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "964fa7e5c0baf9c02d69efcac01ecc4dbab6134c78a20417488f4ebea4221eb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "028bfa4ddc1c8f4785d1f562ae38cff95ec15370befe76de1566d7435623c130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da07d7daf6ce711f8ecb3ed41d4b909c4891eba80b419760c81efd087e3d569f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9426ff4096ee0b3669176426807f88cb07fd9307e69ee0b3dfeafc267441abd"
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
