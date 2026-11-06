class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "eabb7f383f45b98d852b5a4787ff16a6fcbaca3dd1aaf9213a69de78f14fdc75"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c5e11310240d02bcfc99540a6b0dedb3f7ea8b0c0c063dacddcd3bf29515218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef025616f12b6ab45cc39f27a6a84ccca9a4a6a9cfa859a4eddf75e24b8264a"
    sha256 cellar: :any,                 arm64_linux:   "168e094730ce3ec05112dbcaa6fd28040e281ec1e3cdc12fda80afb2effb125a"
    sha256 cellar: :any,                 x86_64_linux:  "34d9182ae9edf37cc69836da284f82a3da1afe5ea5e3982cac2e6f95189fecb7"
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
