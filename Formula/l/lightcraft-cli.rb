class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "d635ea3de98b299686511b5663f6bd978353e0f491dcdbfe4b6f34267366e5e1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a896361ed50ae22d81fbfe1fe894a27f25a4a5df184bde7a4900ae5d9538d07a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22425d11aeb8ad6162303b57533f55bbe2ee792a269203d4001592df26fee910"
    sha256 cellar: :any,                 arm64_linux:   "5cbe4d362714cc6ea427ad86e176ae30d77503b8aead3ac71895cea96ff65a35"
    sha256 cellar: :any,                 x86_64_linux:  "e4c88e9237e39c584fd3b1bca6db6963e74cb4236a6c975824b46503c202976e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/lightcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lightcraft-cli --version")

    controls = JSON.parse(shell_output("#{bin}/lightcraft-cli controls --json"))
    assert_includes controls.map { |control| control["id"] }, "light.exposure"

    cp test_fixtures("test.jpg"), "in.jpg"
    system bin/"lightcraft-cli", "render", "in.jpg", "-o", "out.png", "--set", "light.exposure=1"
    assert_equal "\x89PNG".b, (testpath/"out.png").binread(4)
  end
end
