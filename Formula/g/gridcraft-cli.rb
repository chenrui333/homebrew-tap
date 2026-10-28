class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "b33b6ab1f9032b0ccf6fbbe281affa618a325bf54030fa0d017a7fc1bf2f8251"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3aeca93359e14abc8969c35259877512e1182054c82ebc1d38dc1ae042200547"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6408e93d2696cead17be8c055dbb02f2ada6b3a2012bd786bca3ca008cd464f"
    sha256 cellar: :any,                 arm64_linux:   "61238e63b78ce1f2e7bb599d417e18d887305cb3ec85cea6f1b55c73b6ee741c"
    sha256 cellar: :any,                 x86_64_linux:  "26aae5fd91ab7323e77915855e4f37c9772799ca8ce4dc36a24ebeceaa2d8b4a"
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
