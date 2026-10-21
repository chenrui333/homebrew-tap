class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to edit, convert and inspect vector art"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "69be265cc6f6a9497aa950a99c09585e8c9a3b0d25f4230391fd53c528a35782"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9b5e431b82ec6e44d38ec11f8129624cd3108570e507c72f99494b444123f97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16e0f17029df0d4e75f999d89be1d66b42af49068169de24a0e041eb2e31929"
    sha256 cellar: :any,                 arm64_linux:   "f4f841913a5e2692d81bcba357612cbf83dc8483c5d875f243245dde64f39eef"
    sha256 cellar: :any,                 x86_64_linux:  "dbde4143ef3dbcdb7508b696fac6fddf4bb042f35f5b0200490fe065477a9a7d"
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
