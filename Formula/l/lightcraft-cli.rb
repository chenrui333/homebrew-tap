class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "f2eb8faa052c7ec4c28b60607259cc97e6d88c98575a00f5daaa174daf96ccde"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b9b0d975a806a7ccd1998f6f569db8710ab870957183dab0c91f17cc8f85836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c753614a7efe598c1f3359dac628c1487e77e292ededd6b1bb243197e735b4fc"
    sha256 cellar: :any,                 arm64_linux:   "0dd7905aad5c55fe3555063f5265ee0ba6d8824ad9aac6af8c3d973562ee81dc"
    sha256 cellar: :any,                 x86_64_linux:  "06e88f7281e198c31ba1d20d1b23d8539fdd18c04fba94f093f47740b9ffcc7b"
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
