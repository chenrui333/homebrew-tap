class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "e795a6e1879ddf756fc34141539fafb5a74e654057db6492f44b8e5aa91e5dc3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e31ae26bd56c5f013ce53ea5d197d45324321d0517ba8cdb625b8d465762cad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6b9542d08283105b6b6f8770dd1d5285b81b4ed098365057937f14c9dd04808"
    sha256 cellar: :any,                 arm64_linux:   "9836dd0808d98fd9fa0c562e9025ec2a2cb4d51d7da1dbcb866eed11966d1cbf"
    sha256 cellar: :any,                 x86_64_linux:  "456cbfc652ae992d4b59608e5633b8c93bf45d4111b89a59ae7236d315db437c"
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
