class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "dfe0f859ff587636cd13ab8359d340f62eb0d6d74df76ec23dda28d27c4ecffc"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdns-scanner --version")
    assert_match "# mdns-scanner configuration file", shell_output("#{bin}/mdns-scanner dump-default-config")
  end
end
