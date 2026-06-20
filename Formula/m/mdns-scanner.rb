class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "5212eac2204244c4cfeb7e9f5c9e34900f3af59a07ac1ea2d332c6213a9dfe83"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e516450fc60ad15df9b1bf07571eca6d5bd56532a4930ce84aa324d913bf0fb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c99e84ccb6a13b0c0deaff8b2a512b8dccead0b638c06fac2e326f0a5ab4c1ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb50f1876659a9badd0f2b673fa81f910b2b2be4f577b279fbc7704445f1a3e"
    sha256 cellar: :any,                 arm64_linux:   "fac4e7973f8aa148387362d9470b0a7fe95ab659a6bcd17c2bc3e9fd836a89f0"
    sha256 cellar: :any,                 x86_64_linux:  "0862d6f7b634e598f7df1075de2c2ebdd15a3348600cff4d16c336190ee93362"
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
