class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "fb8df3ce93c0d8dc7702f95683197fd8f50c1af210e382b05627020ed862b29f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "738003fc3e837418f73f213895e7f6123bb8069803d8f58735153c2335c4ff59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1400a845fdce74d31291ac908c0ca329ec5fef6d5390e9e928b1788f01bc67ad"
    sha256 cellar: :any,                 arm64_linux:   "faac48881ad36e42c45d5afa3f0394257e0052c2ec0459f5b3e83672f7f851ad"
    sha256 cellar: :any,                 x86_64_linux:  "9b76e38b8b51df20f336bb782992f0540062316a92641dc07a3dd4ad54f57672"
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
