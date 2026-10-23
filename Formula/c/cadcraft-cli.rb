class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "374177d50bd52ee38d724956f823741e8ac5f7e469fba049df3f421882820868"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa6904c34952860a11f6951e28462c134c92d616d648ef9c2b3b2c40bdaf1554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e1e9ff47ba20637fcc76219716754f668fa81f5cb7221576fdc5950cf83399"
    sha256 cellar: :any,                 arm64_linux:   "6ff34084025d95fea958a193b485380f1cd28a8ebbaca22b23e5dac916fb6ce7"
    sha256 cellar: :any,                 x86_64_linux:  "3c0275258a50a5ea9c71b4e61402d2ef96fc645d7a686a0c93a285d186acd2da"
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
