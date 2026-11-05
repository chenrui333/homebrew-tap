class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "c81f84ada82aee7d55d09fbf3a69c35862e89df92666bdb69a9b8b9e1df7ee46"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66fd396bfded02ca0a24ad0198d245340736b285485b78af20a8414898cd2d61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bbf93a653cd4096cfb5919a2e56d08f77c9a057f97d0576e6399c9eb4ce33dd"
    sha256 cellar: :any,                 arm64_linux:   "964f9663e71d399ff8c8e5c1f5954d26a95df2254991333d9c256ada3b468546"
    sha256 cellar: :any,                 x86_64_linux:  "40650f61eac2f2f740690107750d4374ca88d51b7dfd6b2fd760639881512154"
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
