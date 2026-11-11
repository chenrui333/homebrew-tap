class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "9d2fbedfa18e4d610909edf06705d2aa43312bd507a6bbb1a9f4c2be90ad2d7b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c72742ed2fe382daa190a2e37a2d7801f19a5912cd504a4cbd9686e6f89ea9fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1118a297f91287a718a969450b1438d54be3cc7574dd5e91b19b43f8a11f6737"
    sha256 cellar: :any,                 arm64_linux:   "e0a2a35502f1236ace1f078409b3c0871b268eaeb06e15dbbd45f8a82019324b"
    sha256 cellar: :any,                 x86_64_linux:  "fb0bb34bbed608281cd1ce4b655c2dcf36db724c993c4ef4660f52faec8f24e1"
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
