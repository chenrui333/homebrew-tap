class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "072dc9e9deefea090d3f98a9434424dfc212c802171e5dc6595f7704cc38bf44"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e61bc55e59ec2065e8fea7c44f6f75f7b30a349d90a6c89f7fe1c1784ff7f74d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9fbbdc48dea363e838f9b7614f16c205f7eccf54ba0c19808a08168fb4a0048"
    sha256 cellar: :any,                 arm64_linux:   "1d88396264e359071f663a00a77af37a7ba8c0b448bad3756231884c75c07aad"
    sha256 cellar: :any,                 x86_64_linux:  "21fa48876b1dc0c36ce538f7325fbe4dac80efb588bafa89f64114e2de71614a"
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
