class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e79b5df21e3044d0dab835f17c7a47497d477bfae642e591e03810b428e60123"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

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
