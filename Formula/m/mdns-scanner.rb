class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "b2a244098bacecc1916b50359c2196df8cc549644938316802d15e0c25c496e4"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcf31836c8ca888165ebf54df7e63111dde48d55381a3968a48c156ed3c827e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90fec40c238bbbed33d282468dc4d9b0f6a336b6a0897d49659cc287bcd29db1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8797abc157ff94e2d29b197db95ad9146cbd5e1e7fe301bb000366dd9110645"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46f7e6cf1fecd2d28006030cfd955d2a25f4c850ef8898b52afd259ca45d5bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d00bceb877be6adc6e4a665ce56db93bb986e8fdf7656dba5a8ce24e03676c90"
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
