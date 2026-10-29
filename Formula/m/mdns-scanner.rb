class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "44126fa4c8ee783a427c5edbea3422c04d82671583668d363091c43515949165"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c8c31df4001d72376cf67bec51ee871b6118ab0f8843881102f645f982999d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d6fab6d3d9013e5ac0b592e7535e7469a97e1a648511eccbfbe45d709ae191"
    sha256 cellar: :any,                 arm64_linux:   "31a71249a93d9292569a668e318c307dff1d708649ff3fe18c31ea08e313108e"
    sha256 cellar: :any,                 x86_64_linux:  "6134fb6989743b398f533ab721e26c2b227e27b040feb16d87bd300f3e8c56f3"
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
