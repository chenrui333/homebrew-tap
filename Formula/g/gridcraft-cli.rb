class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e79b5df21e3044d0dab835f17c7a47497d477bfae642e591e03810b428e60123"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eb0a1ba35e0f396f9ec6a929fda96a96a30ae9e1d0c0488667d2626ef81f598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ded438f63f4872fcb84db884c64db767a5f912186144719e26501496c755074"
    sha256 cellar: :any,                 arm64_linux:   "d76a623d7520f267645a2c99805c65bdd1d140228bcc41677e3da482138edbcc"
    sha256 cellar: :any,                 x86_64_linux:  "69b7a2feb859891a1585388fb3cac5f8f3585607a4877641d6c996480d034dfc"
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
