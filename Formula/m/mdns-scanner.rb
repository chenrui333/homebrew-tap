class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "09bc30c592f077010418359e6e04b2837e1fb776f694eff196d2dd4e7e7f0dfc"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b84f56634d09659d893a14038d098c8e1be57c07a24a57728bfbb73d8393643b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97f03253d2e453b81e0defd204852da6f7b8514df085d3c4ddbab22d73d1da28"
    sha256 cellar: :any,                 arm64_linux:   "618eca4cde234f9a94496acfb08484d7856be116813a5b5c348267dba75a3412"
    sha256 cellar: :any,                 x86_64_linux:  "2fed28dc00de267c1549fc639dee8c8a8bb19ff6556e2ec56a423a02f167db01"
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
