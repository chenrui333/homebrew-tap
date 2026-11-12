class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "4adb7b981de97f31c61e5be67ac7b2bcd84e2559647b5c8c39561bbcce199c5e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a0656ac4ad075b337295e7e9a645af1918fc50fc5fec582ff6664af22a281ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e33be210287f168e5c133670a8e4f2f3b990bea40e3c74abb6103f1c854cfe0f"
    sha256 cellar: :any,                 arm64_linux:   "ae8bfbdfc7a20d52fb47b52f3aa92c38ade66bc2814a5831c0e06e3548b132f8"
    sha256 cellar: :any,                 x86_64_linux:  "12f6a11ed3fd7cb9681736466a8de75afa2985406407494840013d7da6078d9e"
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
