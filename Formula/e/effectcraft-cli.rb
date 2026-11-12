class EffectcraftCli < Formula
  desc "Headless EffectCraft motion graphics renderer and scripting tool, with MCP"
  homepage "https://getartcraft.com/apps/effectcraft"
  url "https://github.com/storytold/effectcraft/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "f913a744eb29e1fe411ad6c806178513ee5afba2c59a89872dfdfc4ecfc44358"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/effectcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66cc8f4d97a43754f3e4081cad649d5aa86fb1b43c1dcfa5a514125344228017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "196eb2e69227604b3276e70f10aaad8363b478d9030d1dabc7005dd2653f5f88"
    sha256 cellar: :any,                 arm64_linux:   "cfb245ce7d1b1858d939c5e18821de41ae0bcc5041823ab159d364f3f82f1dff"
    sha256 cellar: :any,                 x86_64_linux:  "a9cc56ff942091f7a413e70741468b1468375e6888c42138ffd14abccfa4b099"
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
