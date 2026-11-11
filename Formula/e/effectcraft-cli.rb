class EffectcraftCli < Formula
  desc "Headless EffectCraft motion graphics renderer and scripting tool, with MCP"
  homepage "https://getartcraft.com/apps/effectcraft"
  url "https://github.com/storytold/effectcraft/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "b1345d0f5f8ba0942d6b97603d47c2755f3f073afb9ed75f0ed80ba41a7f3818"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/effectcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec25952020707bbfe5a1fcadb19f32742b1b9c49fa373ca14b70629e9c8f5ab1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01fa7b93d7433b8e9938c8ae4a9a10e4b20e120c53c45f3ce3a46cdba110390c"
    sha256 cellar: :any,                 arm64_linux:   "cee9e43cac5865a17339dad0b03e5b68f137023d1d5bef2c8c7fa9afdf5b2bc1"
    sha256 cellar: :any,                 x86_64_linux:  "a1f7b74d5c130d6001d15037b7505e8174b45319892f6cf0b5c221b5ae95c432"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/effectcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/effectcraft-cli --version")

    params = '{"name":"Main","width":320,"height":180,"duration":3}'
    output = shell_output("#{bin}/effectcraft-cli exec comp.new --params '#{params}' " \
                          "--empty --save-as test.ecproj --json")
    assert_equal "test.ecproj", JSON.parse(output)["saved"]

    solid = '{"color":"#00ff00","name":"Green"}'
    system bin/"effectcraft-cli", "exec", "layer.newSolid", solid, "test.ecproj", "--save", "--json"
    system bin/"effectcraft-cli", "set", "Main", "Green", "transform/opacity", "25", "test.ecproj", "--save", "--json"
    output = shell_output("#{bin}/effectcraft-cli get Main Green transform/opacity test.ecproj --json")
    assert_in_delta 25.0, JSON.parse(output)["value"], 0.001

    output = shell_output("#{bin}/effectcraft-cli render-frame test.ecproj --comp Main --out frame.png --json")
    frame = JSON.parse(output)
    assert_equal [320, 180], [frame["width"], frame["height"]]
    assert_equal "\x89PNG".b, (testpath/"frame.png").binread(4)
  end
end
