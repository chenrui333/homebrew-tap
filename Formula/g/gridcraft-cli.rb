class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f705a50d96be1dcf6101fb0973b384fe40de5eff06981017136521d7ca1888a3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4db22d38c58796094e1ecf42ccda4dadb1e52f7aff88a429472f616745127dce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79dd5b8d0cce1e8e71ce902f0cf89520c0b4dfcd5da4e8d33005f0f372a0d343"
    sha256 cellar: :any,                 arm64_linux:   "f02507210d82152f77040ad58a9547fe886988f0b02ae0c4895c97cce9d13925"
    sha256 cellar: :any,                 x86_64_linux:  "6e45f6fca4585d2d960af415e825a0382d47759b4aaa4d8d3f93a46deb9a919b"
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
