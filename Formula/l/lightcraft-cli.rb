class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "da592ba01b21c8a281067e223826b62e3988a0c93032297c9b23e7b8fb844baa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c0e498830a8e4f59f39efcfd96652b27fc6080a4d6ce43e3d2086cd7cb4b4b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5581ad7f44be85fe868daec6a4982bb3bdc439ba00025c4758082114011dbcf5"
    sha256 cellar: :any,                 arm64_linux:   "a42a26765d30f1b7655875410c8608c72ef3610f30194993532511c242d7cdce"
    sha256 cellar: :any,                 x86_64_linux:  "df09083278aa0d8301e892c6abff9695fd54023ab6d5f4abef0af1a32e6a39dc"
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
