class FigcraftCli < Formula
  desc "Headless FigCraft design tool to inspect, export and script files, with MCP"
  homepage "https://getartcraft.com/apps/figcraft"
  url "https://github.com/storytold/figcraft/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "809f52ffc049bfc05e3a297c8794a789199d4548ada5113048e235a3bfea4efb"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/figcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee47146fc2172526dcf93fbb476356e8b2c113ff08e4234c1d35d0bddac8fc78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b88aac58a78a316e6385d4a7756b0df90923526a119bb677a1596ff4f64fa9"
    sha256 cellar: :any,                 arm64_linux:   "53986955f41ac57e4f472078fb4c013c7ff05462a18175625623ab4d94f1d45d"
    sha256 cellar: :any,                 x86_64_linux:  "20a17859dba503125a332884079c68471b6d4667cff2a103d13aa8368223b237"
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
