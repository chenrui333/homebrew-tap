class CadcraftCli < Formula
  desc "Headless CADCraft 2D CAD tool to inspect, convert and script DXF, with MCP"
  homepage "https://getartcraft.com/apps/cadcraft"
  url "https://github.com/storytold/cadcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "73f4696bcebc16e9a1ee41b24c7732e7be0ca8b3627276f584ab0b7f54cfd752"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/cadcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6513c9460ffa7bb00e6514ca8a73925f8ad3aa763792246b7819c907c357ec47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f5b637fd2eaced30837676adf2661ebe963e53904bc846aad2414fd87b7d188"
    sha256 cellar: :any,                 arm64_linux:   "2150a2b85185f35593d067e72a1f33c163725f6a8f0bf17bb69866aca0796758"
    sha256 cellar: :any,                 x86_64_linux:  "d3c1f6a6f2d15517718b30a211cde5225df362eb903213e33810e8249f5f6891"
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
