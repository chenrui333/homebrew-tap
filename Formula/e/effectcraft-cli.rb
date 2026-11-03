class EffectcraftCli < Formula
  desc "Headless EffectCraft motion graphics renderer and scripting tool, with MCP"
  homepage "https://getartcraft.com/apps/effectcraft"
  url "https://github.com/storytold/effectcraft/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "9d34d06f8cf3d26b9641d17a01c5cb5e823a7551f934cc3426ae98d9b94020e1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/effectcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23b2a4acdf906d3ead7976128f1ad418ffc555bff05fb569dbb665d8c49b9259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0237899dd5b54fc03e671576c55d39f096004ced38b67501c7d6b59f5ae2466"
    sha256 cellar: :any,                 arm64_linux:   "ff8f36df7d212a744e6310855ecec3570a6f57adfd8488bab1b99c5b772fb965"
    sha256 cellar: :any,                 x86_64_linux:  "ba378b9a0d9319e41e774ff737263fe75c2bd555790d5177c5dfba6cc291c5c8"
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
