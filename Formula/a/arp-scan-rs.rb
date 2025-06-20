class ArpScanRs < Formula
  desc "ARP scan tool written in Rust for fast local network scans"
  homepage "https://github.com/kongbytes/arp-scan-rs"
  url "https://github.com/kongbytes/arp-scan-rs/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9cd8ae882d47aef59f79ceedc797a9697b0f1b81916488a43a84b0a807b482fa"
  license "AGPL-3.0-or-later"
  head "https://github.com/kongbytes/arp-scan-rs.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arp-scan --version")
    assert_match "Default network interface", shell_output("#{bin}/arp-scan -l")
  end
end
