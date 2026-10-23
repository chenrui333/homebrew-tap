class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "374177d50bd52ee38d724956f823741e8ac5f7e469fba049df3f421882820868"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1272328db2a90fd6089f86599c4adf1f5a339aaf43da9647b59c7e6f62a5584a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b35403a3e1df08e9b4d03bbeeefb6894eb2ce5fb9d5bc94bd2bc004e17a8123d"
    sha256 cellar: :any,                 arm64_linux:   "208af7913b872a1087ace8a21a12b0e1ce1b1676dc2910ff5988c1b1183c4906"
    sha256 cellar: :any,                 x86_64_linux:  "bb230fa394443b8bf7a1d76871641c6da3f397617f80d9b3ed1d2b03d1077d8f"
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
