class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "f3cff1118b31be65ccf3706fed6a62af332adf26103a3cdb4f3f720af6b66dea"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90c505ef0e2108987a1e7d5e5a758191cea4927455a61958cddfcbfa3ea2c755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "753ff94bcfe52975ce054ba91979f06cd8a5e2f4403d28472a56c75e0b11c6df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d79d1f0c37d42fb433a3e887b170cfa7009def05f5318895a3fc66751f287ea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ced6f7460db21fe36dd824247d44d13c1751dcd35f0e8b908bd63ae4127d705a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ccfb91925ef9f22fcf6087a07e4283d1f64bc3d2c2e14bac6265ea88be57936"
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
