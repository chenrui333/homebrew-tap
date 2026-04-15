class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "36e4b242778bf66776ae7488f7a2dc0762fa16150e9a70a773e4235bb60b0280"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57894e094d0a9f0dddd821a2e12cf9f9021341bd60ded987485ac3f99466bbbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6d580cd6855494c4a1dbe770cab6d41be83300a07aa10fcfe93b7071ef465a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bed3c31ff7d314de1e61d85ff75c869c41261955a68ae99b01a805cddb01ee27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41c384d1898b530810bda8425c1e706239a51b9c1cfe86978b119950e8c97751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76caefee3fb65246c45ba6d6eb7e3ffccd352c7c91ef8a2897ff26bccf133af4"
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
