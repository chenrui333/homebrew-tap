class EffectcraftCli < Formula
  desc "Headless EffectCraft motion graphics renderer and scripting tool, with MCP"
  homepage "https://getartcraft.com/apps/effectcraft"
  url "https://github.com/storytold/effectcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "804196c15f4e5edc337c4b6723c65d0f2c988913902ffc1f186709d22aa96c05"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/effectcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64917a88ff279de4103749b3d043bc93fe14beeb707ae973ba9865581daf0582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca3ca92865199542e1d5c44b7049d0e6990c0980ab6dcf15e4c3d1a49cfefc65"
    sha256 cellar: :any,                 arm64_linux:   "7371587361521cf32bd34c453b91aaa6c9c936530c6ad243c2f7ce6fc5beae8f"
    sha256 cellar: :any,                 x86_64_linux:  "6df8cbd33b21ec9ed82fd9cfb4913c00d6dcb9d7364763520e589fa14cb31bec"
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
