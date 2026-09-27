class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ac9246ed14337dfe4b960106f7f5b32f878a49bdef535276150654d67fda9c7a"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c651096ed1b1b59d405ca921b12da872e8285dfda725731defa721eb5754a2bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c2397f70f7d631b0f769fbd3987a7585f0fa0e74896c87f3838c7b59b2df52a"
    sha256 cellar: :any,                 arm64_linux:   "10acdfef72157c388abc464e79e74c0d3307bf40a8a610f7f64e45cc22d5dfc1"
    sha256 cellar: :any,                 x86_64_linux:  "c948f0bed8676def8921c35fd1c1253d0aeab08ca9c4b2165ab6b3fcd3b2d0f1"
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
