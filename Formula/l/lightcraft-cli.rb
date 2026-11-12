class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "d635ea3de98b299686511b5663f6bd978353e0f491dcdbfe4b6f34267366e5e1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0d515445b86477097e4b9ed1a29aea14dae1cb9b4657ccc8d3b1393eca13693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "420fb998d73d7b4c67311fc3656ea9a9918e7530538ce7f9269a9827fbd5dbb8"
    sha256 cellar: :any,                 arm64_linux:   "3534759ee24920e0a06d7a4ad5ae09aa58ab42bc22fe853623ae284724969cb3"
    sha256 cellar: :any,                 x86_64_linux:  "3447a35c266eff6ab4c7ffdb82b263f0627664bd7744c302cc4a9d47344810cf"
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
