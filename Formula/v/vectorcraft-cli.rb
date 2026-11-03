class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to edit, convert and inspect vector art"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "d051a395f62511b52e7ad023f3029bfc8846871b5f2f61b19312f71e777c4efe"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35dca5293e29a3a167ab6e7e70c7cf35540d6b7bcd7ab22d7fcea6a86f4fbb23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9c602bc5497f278d85958a6e75c5853d57ad46bc51e93b96da8b769d0992d1a"
    sha256 cellar: :any,                 arm64_linux:   "0caebdedb175cc8d3c5098917508ab67411c5c227744088411eab8a64acf29aa"
    sha256 cellar: :any,                 x86_64_linux:  "45d84ff5ba3dfc0e1b7f6d0bdb92f5085a585c44209ab52254bb4b11be969682"
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
