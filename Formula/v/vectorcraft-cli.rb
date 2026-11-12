class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to edit, convert and inspect vector art"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "529bbf6a3ee7349fef75c4d04a5db2dca78b6116d2fa42cf1caa5d95677f1292"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f4ebaeaa0efb29dea6c12fcef38446b45043266f6e9228cb9a465eec9e5c944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbfdd15bea143dc1a39854b01c2a41e1c6516823a75fb4805160fa3b1cb8cdf0"
    sha256 cellar: :any,                 arm64_linux:   "65a2538b1f1c969a9a50e3e371c6e3dc52878c74a67a27b1a48ff53b9cbe91d6"
    sha256 cellar: :any,                 x86_64_linux:  "4d5d3d67bab14da2b3b8f2f1c86f065d2629dfaabad9dab3f886c231e04d2c53"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/vectorcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vectorcraft-cli --version")

    system bin/"vectorcraft-cli", "run",
           "--cmd", "file.new", "--params", '{"width":200,"height":100}',
           "--cmd", "shape.ellipse", "--params", '{"x":10,"y":10,"width":80,"height":60}',
           "--cmd", "paint.setFill", "--params", '{"color":"#3366ff"}',
           "--export", "test.svg", "--export", "test.vectorcraft"
    assert_match "3366ff", (testpath/"test.svg").read

    info = JSON.parse(shell_output("#{bin}/vectorcraft-cli info test.vectorcraft"))
    assert_equal [200.0, 100.0], info["artboards"].first["rect"].last(2)

    system bin/"vectorcraft-cli", "convert", "test.vectorcraft", "test.png", "--scale", "2"
    png = (testpath/"test.png").binread
    assert_equal "\x89PNG".b, png[0, 4]
    assert_equal 400, png[16, 4].unpack1("N")
  end
end
