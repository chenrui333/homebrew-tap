class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to edit, convert and inspect vector art"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "2e75236b5d1f779e21cd03f44b7486149afb272ad893b9db7d0cfff1beb51bee"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e1722573952246c07aafbc1ba06a368c9b13428b81c432e18f3dd3ba8ffa44f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0510d042f34271e2da5acc73ff97f1528f0e4a1625fa0cff3c877fd6939e9bb6"
    sha256 cellar: :any,                 arm64_linux:   "00f462838faef62017217a5f57dd8a716ec62de1ca92d49c609190548c4a3cf5"
    sha256 cellar: :any,                 x86_64_linux:  "a0efbb118ce33e742dda60d0c5d7cc294b5c4d082ffe4744bcc3078257998271"
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
