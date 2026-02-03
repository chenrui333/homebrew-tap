class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "b2a244098bacecc1916b50359c2196df8cc549644938316802d15e0c25c496e4"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62250e0b4c3bca374d2295b4b2ea764d7559456f2047c21a6b07c0b16e95e3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31b3d57c02d2207d26b01f684b6646c32e6b8c8b4b280a63254239495f36e836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8014d36f94a436739d59efff24e1ac6fd1d54053851c3eb1e0564cf964b45ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73023c69eeb3e6f514da032162a9ef695442705f7923ac50f799116023b4a5f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089c11ccc4318c598c5ced6c5bc0af78ce42920467a434e825ee7197316f7ccd"
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
