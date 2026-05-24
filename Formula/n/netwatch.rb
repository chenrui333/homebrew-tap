class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "7ee09f20ac55a291fe78dc3c89fca38cf38a4b1f3cb6dca5ec7b068e779d41f4"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d7b478a4ea6cfb9bdc8e3a940faa5dd135bdd91a0da90c21ec6b4814fcc9a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1880faf1535085eb5f312cc8848132ceda5ecab5737250a96d7e5ba78c95b92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66f64b781193a68193c91fa59b7ec52f2b3b1f1f411179963e504f97185eb34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d24203dcbb87f18209c7ef0fa55fdeabe109965dfe3e36f4ba5b0e9cf97ac634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a6b3ca94a553cbd1e458ed879c53386d424c5804aaff25731b9a2dedf4ffbb"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
