class EffectcraftCli < Formula
  desc "Headless EffectCraft motion graphics renderer and scripting tool, with MCP"
  homepage "https://getartcraft.com/apps/effectcraft"
  url "https://github.com/storytold/effectcraft/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "55cd297c37f354e71ada2432f773b9be1f191ae2cc73f397229e4defe82b5f98"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/effectcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "75277b72ad18a3aea8c178249f3b1e2bccfbc53923f9f0e4354d67d7b56299e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b8c0f231e29b0e96e8bddbbe17942a5403a151f78c4cb59ad49cd22b26090bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16f04dc0a8f13d899e4f0af83294ea20bb9469414ddfee5bd560ce2c4b37d4d0"
    sha256 cellar: :any,                 arm64_linux:   "0e4bb751a7ef48a336805a15e2fbecc81688ad3f6cf04710bcea59ed5fe49206"
    sha256 cellar: :any,                 x86_64_linux:  "315b65b904ccc6e1207acdc9b77cf7df3e287475fae19a869db1347af3fc7d31"
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
