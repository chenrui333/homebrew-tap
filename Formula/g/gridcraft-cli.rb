class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "eabb7f383f45b98d852b5a4787ff16a6fcbaca3dd1aaf9213a69de78f14fdc75"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94462e2f4d844cfe0466c4e73b1c72ebfb1d2c412e243a339c588dcd45574676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dcac5107633a19ff54ef835dc23814a0d0d370c4d2a7eaea7a65b328a804d11"
    sha256 cellar: :any,                 arm64_linux:   "52f32cee8fc08d6998daa3fdee9911d9b55c6558fb455c0da2781dfd6f25c296"
    sha256 cellar: :any,                 x86_64_linux:  "60afd3d1a0cd8cf42b5d09baae2d33926a1ba609c5cfd19a94e0f58a72fc8928"
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
