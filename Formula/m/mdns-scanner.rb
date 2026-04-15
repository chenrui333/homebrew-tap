class MdnsScanner < Formula
  desc "Scan networks for IPs and hostnames, including mDNS aliases"
  homepage "https://github.com/CramBL/mdns-scanner"
  url "https://github.com/CramBL/mdns-scanner/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "36e4b242778bf66776ae7488f7a2dc0762fa16150e9a70a773e4235bb60b0280"
  license "MIT"
  head "https://github.com/CramBL/mdns-scanner.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e585b4404ba09ec381874bfebb0b0d0bc12fdf1ce70025105c61c4c94b1fac1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ce2c03774f8e5be4e7a7b13a01d63e35ad9911ef35339492ad5a69b729ac8bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b9c001704abedd66f642b36a0c52a05a9e7d6f715b7acea76fd7240baa5ea3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402bc1a6b47b375fe0ceb3822463e189eaf9108537aa29a3a8c2abe627cc9425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186072e6b497d8b983eb9fc99129a8ef29fe67b9c1c28d5a87bce88d82631fcc"
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
