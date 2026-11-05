class FigcraftCli < Formula
  desc "Headless FigCraft design tool to inspect, export and script files, with MCP"
  homepage "https://getartcraft.com/apps/figcraft"
  url "https://github.com/storytold/figcraft/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "993e8fac22117c794a6e91dadd86f5a99914307d30e9ed605f56f84f7fa7900e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/figcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8b997ff6d13f328689aa6defe5cf694a0a3cb261fa2dfc9cabd05648672823f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "582d778a1a5cb4393550b15c925003337961bad8c410f4790a3c1c2fc84c52cd"
    sha256 cellar: :any,                 arm64_linux:   "14c8a5cdfcaa697e9dde8690af31361cfde4f0a545118d1089e98c61ba8b4c41"
    sha256 cellar: :any,                 x86_64_linux:  "f29b0a2d28e45bdc3b6b345c780658be30aa373f55ff45cfc71f71fac7da6801"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/figcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/figcraft-cli --version")

    (testpath/"script.jsonl").write <<~JSONL
      {"command":"frame.create","params":{"x":0,"y":0,"width":100,"height":50,"name":"A","props":{"fill":"#ff0000"}}}
      {"command":"frame.create","params":{"x":200,"y":0,"width":30,"height":30,"name":"B"}}
    JSONL
    output = shell_output("#{bin}/figcraft-cli run script.jsonl --out doc.figcraft --no-system-fonts")
    assert_equal [true, true], output.lines.map { |line| JSON.parse(line)["ok"] }

    info = JSON.parse(shell_output("#{bin}/figcraft-cli info doc.figcraft --json --no-system-fonts"))
    frames = info["pages"].first["frames"]
    assert_equal %w[A B], frames.map { |frame| frame["name"] }.sort

    system bin/"figcraft-cli", "export", "doc.figcraft", "-o", "out", "--no-system-fonts"
    png = (testpath/"out/A.png").binread
    assert_equal "\x89PNG".b, png[0, 4]
    assert_equal [100, 50], png[16, 8].unpack("NN")
  end
end
