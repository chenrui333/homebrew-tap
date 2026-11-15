class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "4adb7b981de97f31c61e5be67ac7b2bcd84e2559647b5c8c39561bbcce199c5e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ee2b2fa62b5817abd174f309ee1f250fe9b6b84d58c844adbc1688a06227e4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b92ab8becc68edaafc97147bbe0cc56b10938e91a977c1ff0c2f48e598cc8a0"
    sha256 cellar: :any,                 arm64_linux:   "2aa4023d9fd0f0cd0142c814e8670d8dfe804c9d9b65a3fd0cd7aa3871c50b61"
    sha256 cellar: :any,                 x86_64_linux:  "c286d58f5fa94881ab84f63cfdc6636cb67aeacc76b2e35ea2c52c7fccc58696"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/gridcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gridcraft-cli --version")
    assert_equal "6", shell_output("#{bin}/gridcraft-cli eval '=SUM(1,2,3)'").strip

    values = '{"range":"A1","values":[["Name","Qty"],["apple",3],["pear",4],["total","=SUM(B2:B3)"]]}'
    system bin/"gridcraft-cli", "run", "--cmd", "range.setValues=#{values}", "--out", "test.xlsx", "--quiet"
    system bin/"gridcraft-cli", "convert", "test.xlsx", "test.csv"
    assert_equal %w[Name,Qty apple,3 pear,4 total,7], (testpath/"test.csv").read.lines.map(&:chomp)
  end
end
