class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "bea9a26e46fa5696e2c8a29ee2cd243add01a3cc357f3b1287171e45f77bf563"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62fbe77d8c0a0f2d2d6848d093ed08862cc4e481387e6a5d929d2afaaceadf80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2175184f23f4890c9b9dd70b2c1c9d56706975ec3d4a154c4af05a94eac2e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4345bfed6fe9e4443098e1b3c2b68faaa2cdd6b0cb04f0f98364b4390cbb4456"
    sha256 cellar: :any,                 arm64_linux:   "f8d3a59608417df7083163872a6b9f96adbb55738806776fc785df1e4f361d75"
    sha256 cellar: :any,                 x86_64_linux:  "7b09e493fc91f5abd72c52f2c436a5436033b65f2a808ec997830612343e1fc7"
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
