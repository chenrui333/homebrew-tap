class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to edit, convert and inspect vector art"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "82fbe69b40fe1e0603faf6900b80ecff381143a2870fe35636f0fd6fdfe92109"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f9a386fdd7341d031009fa742b76cb24bf25819f909c63e041d3024b881fd85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967456dba920545cb93e51fd26044b7088f546702b5b5baa9f81497a89af13ea"
    sha256 cellar: :any,                 arm64_linux:   "502a377b2dc059fbf6b4218cf045f771223a6be9feb93cf708f9fe9eab77da67"
    sha256 cellar: :any,                 x86_64_linux:  "649344ac411bd8de46b22b34ffa704d41cfdb05592020d949156c0c7d7aa772b"
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
