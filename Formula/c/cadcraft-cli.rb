class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8e275d33b59bdf967a587cb214dede5875c871b789c8a53f4e9646359dcb97bd"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97c2e377e8e441e941d80f0ecda3d00da7c34b417e6bcab49ebcef91794cfe4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23f6f1afa2fdf622f52611523ca8fcfd6ef313894b7da5fdcb499e1da15e9deb"
    sha256 cellar: :any,                 arm64_linux:   "848faa67e2639144d018470989133e2886892ca504a0a840d1609b5fada1a834"
    sha256 cellar: :any,                 x86_64_linux:  "c6de7b9df043644a5c09871915e63a37113b51e548bb671efbe525ca2c8796ee"
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
