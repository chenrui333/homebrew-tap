class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to edit, convert and inspect vector art"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "2f895f0a133de4bf9ab5dbdd7f7ad77fa7c9f3c0c2d3f6a60c98cf00e0ea223e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23e91a71a46140b7c11cf4cdb73c7e1eefb65029ca45b985cdb954d4cae3a5c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b6a1632f22988cdf3605a37070820b1bf884ca11f6bf0f72a8c4862cfeda112"
    sha256 cellar: :any,                 arm64_linux:   "effba9d2d65458a5b26359459751bbff238a8a21770e96e5885d0e0112ee35b5"
    sha256 cellar: :any,                 x86_64_linux:  "1048bdb614b06d27fd1f0e3461a39266b101fc55b8223c253d21690fb6d85d45"
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
