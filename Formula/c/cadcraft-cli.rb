class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "9d2fbedfa18e4d610909edf06705d2aa43312bd507a6bbb1a9f4c2be90ad2d7b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cd3683516de54bdbb4b34e71fcf5cd0f56b88228df3b422de3f76127f2be261"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d85092675748c2e392909d282d7d1f15c56c642f52e3e6a91f05038766b893ca"
    sha256 cellar: :any,                 arm64_linux:   "4caa8e20cd3f7e92e238daee34a28bd22d447a7e57c6258d0f41c155fc4a39f8"
    sha256 cellar: :any,                 x86_64_linux:  "82333d7040bd88d3890050fba884be689191652612d4e8a90033b202b433b07c"
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
