class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "e795a6e1879ddf756fc34141539fafb5a74e654057db6492f44b8e5aa91e5dc3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5f2d12bd53a182a3f14ed49710f76b7ce3a9e4cfc476a061954da529a1da716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c2f8a700c9e68f74611f59b6b4c8455f8649292e5d50880c67d6eb148cdb027"
    sha256 cellar: :any,                 arm64_linux:   "5a126193d592b643c9df58cf97eb609d36459d4ce27c99db2c2958fd3fa1d27b"
    sha256 cellar: :any,                 x86_64_linux:  "b88a9afe0dcceb1345790a4341870f90d029b71285bb6ae52fd5b70e4425b406"
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
