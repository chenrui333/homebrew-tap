class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "9956ef16e0670339db148d60975ebab2c10b394ee566ead11b29fd614e788144"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22514527bec4bc6af83c1110fcabbbe579936bbddb39c93d3d9ffd69c7cad5ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a2dbcce0c439b9e8adb23cd749d570b61068e4a1fbc4116f61379c44d9e7c1a"
    sha256 cellar: :any,                 arm64_linux:   "a63444f322c662eb8ae911aba5624d61453ffb23ee4fa83052cbfa10f29883ea"
    sha256 cellar: :any,                 x86_64_linux:  "adb78ff979e594c5612d87362533f22bf300a4708c6144a3e2d57f16834f9e4c"
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
