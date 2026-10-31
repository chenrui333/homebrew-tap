class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "12f977b2da298770c85d4511a22d36116c214da12dad4ccc6b23397d109f2778"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a42fb7b66817599a7d80d5869d2c51bfb9e267d1238038cb45603ef5ed27a2d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56fd6ca5dac28a5c454e044a9beb0c4e8dd4b4610f0e1c0f7af021105bb13e13"
    sha256 cellar: :any,                 arm64_linux:   "6f1393495b783ab9ac34b876146c7fd0a3a9387f9b3c19b3bbe893b6fbac92dd"
    sha256 cellar: :any,                 x86_64_linux:  "14315d4e096c9df5ce5fda8ac897b42ac734dd855dc26cf1e0bb0b63fdf0db55"
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
