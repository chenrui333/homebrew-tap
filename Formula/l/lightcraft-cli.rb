class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "f2eb8faa052c7ec4c28b60607259cc97e6d88c98575a00f5daaa174daf96ccde"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5908fadad140e8fb292e0b5737fb1456faa43386dd9a3de40bc5754c3bfb7ce0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecefe14c1561ee9726f4848f243e2fbd3f009903c537bb96384e3225514e407b"
    sha256 cellar: :any,                 arm64_linux:   "4b2b72da050e35642304e3d24a1fa2dfac5f4f09607f18403b7dbd3314779366"
    sha256 cellar: :any,                 x86_64_linux:  "dbf6856b7b1ab6e8a781aee27ec72333cedea53a047c68e69260a04431a0b651"
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
