class FigcraftCli < Formula
  desc "Headless FigCraft design tool to inspect, export and script files, with MCP"
  homepage "https://getartcraft.com/apps/figcraft"
  url "https://github.com/storytold/figcraft/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2fc23b4f77dde261b186cb80dd51322f084322726a3b99c7204c0ee9fca5f69b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/figcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d54f8dc2404de2b011ce29726fab0be0c6b4dd5eaf14f466cca3a2a73cf8f339"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1399c4ff34d28e7b1ffdf065ac212ebf2e1295d886a416f48a2d84659ec652c6"
    sha256 cellar: :any,                 arm64_linux:   "43243cb776d557c47ae9b71d6628b78a1cd0a71d045c9e21bb09f528aaff7e53"
    sha256 cellar: :any,                 x86_64_linux:  "00b1b930354c95c8aac4b429f04c0fdc87e801dcc12711aed6e2f78375110532"
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
