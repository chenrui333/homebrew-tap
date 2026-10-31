class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "118303ad98d99767c08415733a052f9d9c01ec24f5d052f3c6bbac64e1e27c36"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5923234298e9c245c6b1f223389cbd778116ee88ef68493577506f19f91d5156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b3d985d9c2ff6ffc82e224a86cffe44f94ccb54b28a37ee0a0334cc8d32fef"
    sha256 cellar: :any,                 arm64_linux:   "8309ab50f4463359f17df97193fd8633619728863e310f073a3e09721d79a2bb"
    sha256 cellar: :any,                 x86_64_linux:  "be48a10c8f1ee3c2049c57df1c8da0fdfb4a0cc7794eea14d97cc4070ac9f01c"
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
