class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "fb8df3ce93c0d8dc7702f95683197fd8f50c1af210e382b05627020ed862b29f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a15f092d3dcb84ed6999b07354defce895bbd7367a6616048bdff24d74897e14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c58aaccda8aab5555dc53d80b646854805efeedcda2c177b27e3c4f0ade71cf"
    sha256 cellar: :any,                 arm64_linux:   "3a7af57bba47b845f58188cf4292aade3550ae9baa1d2397547ac58e86cf4ccf"
    sha256 cellar: :any,                 x86_64_linux:  "ecd52d81a01d6b2a04278dcc8bb75846f3e1cb20aa1305ec72fa08cbd17cb12e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/cadcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cadcraft-cli --version")

    system bin/"cadcraft-cli", "run", "--metric",
           "--cmd", 'ellipse {"center":[0,0],"major":[10,0],"ratio":0.5}',
           "--save", "test.dxf"
    assert_match "ELLIPSE", (testpath/"test.dxf").read

    info = JSON.parse(shell_output("#{bin}/cadcraft-cli info test.dxf"))
    assert_equal 1, info["entityCount"]

    system bin/"cadcraft-cli", "convert", "test.dxf", "test.png"
    assert_equal "\x89PNG".b, (testpath/"test.png").binread(4)
  end
end
