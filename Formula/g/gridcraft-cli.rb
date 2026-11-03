class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "40beb3e9609951abab4ef5ec51a21f0d523279fb56ab68163be8fd835a33127e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e13be1eb274f3b1f4cfe97bdce1ed187fb0119d1c22b14833019f00089044d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6bd19e12154dd512c17a08ad93e48726e571cbbc49d89958c5b4492a1f28101"
    sha256 cellar: :any,                 arm64_linux:   "a83ec3683b40b0dfd884934213222d75a30316ecb31397e932f5ff051ce06680"
    sha256 cellar: :any,                 x86_64_linux:  "072fb590a26dbd9fde89d464a05d3f3cfd776b621d728be22e33a19b4cef30f7"
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
