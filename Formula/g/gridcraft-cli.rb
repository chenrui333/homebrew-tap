class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "b4b07d6b00c7120a0d1128a74fdac0e4873e3764535dc54e68567e5cf1bc0325"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c442adb6c6faa9d82982ebbcff8b804ebacc9d0e8a2d78084d716aa484c4b803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b982d09360af37d091cbcea19d72f1192c40fe392a50e6a54df594c6a1ac3637"
    sha256 cellar: :any,                 arm64_linux:   "e1d3b3703dd04981aa985c7b4437d87e761427460e31e25153d245b0f7073aa4"
    sha256 cellar: :any,                 x86_64_linux:  "1e7e538846b40cde1c77ebbe4f6baed3cdaea27c8f71f0850cd34676c7dbedbc"
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
