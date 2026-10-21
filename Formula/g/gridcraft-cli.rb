class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "072dc9e9deefea090d3f98a9434424dfc212c802171e5dc6595f7704cc38bf44"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54ddadc3f14c4f136bdfb0230298e9cd22b3b20316b7dd8b47e40b7dbb4a465c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95e05f9bba55c5f8cb415a7488cc509c78094eb7758d786c2654225a8a4397fb"
    sha256 cellar: :any,                 arm64_linux:   "eaab5de6d52c54ac164b74b8473f7d7b7c33b9b160bde11cce563e1b2ee31a0a"
    sha256 cellar: :any,                 x86_64_linux:  "eb435e69c8ed740cad7a6e2d768f0cacc47e3a9adc7fc26642af581a67407e81"
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
