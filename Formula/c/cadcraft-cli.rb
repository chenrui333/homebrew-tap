class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8e275d33b59bdf967a587cb214dede5875c871b789c8a53f4e9646359dcb97bd"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12b9f841b709b3a40c7cf287abde4a593ec9a788a9f3b51e51dbb13038084719"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d41390b59203ccc0e1efd3a9e8c04d47ad517831d2109f6906f3dfbb28a838"
    sha256 cellar: :any,                 arm64_linux:   "0660c9d05d9fa987eb3fc9c6a2e34af414ec308edfdcbf27052a48b94c42dac9"
    sha256 cellar: :any,                 x86_64_linux:  "4bab1c200c1f5f79490d1f4f454250029839dfdf911b6aac54ad0c1323cab568"
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
