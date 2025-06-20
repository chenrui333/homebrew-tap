class ArpScanRs < Formula
  desc "ARP scan tool written in Rust for fast local network scans"
  homepage "https://github.com/kongbytes/arp-scan-rs"
  url "https://github.com/kongbytes/arp-scan-rs/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9cd8ae882d47aef59f79ceedc797a9697b0f1b81916488a43a84b0a807b482fa"
  license "AGPL-3.0-or-later"
  head "https://github.com/kongbytes/arp-scan-rs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a4620d3cde1d4a463bcd101c59190ed8bdf6f706698435e43c3faf438bd7ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c07da6cf4f43b34511ee1b507e6b93383d35d5b69e01d0932ab82c1b2f364d54"
    sha256 cellar: :any_skip_relocation, ventura:       "8c6884e91366c9c2cf157efdc020615f45d8508ff3f8ad32e82e986f34458b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601ff0bce624bbb07551883c70cc05d0fb95dc3aa86b69da43489b6a51fc145d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arp-scan --version")
    assert_match "Default network interface", shell_output("#{bin}/arp-scan -l")
  end
end
