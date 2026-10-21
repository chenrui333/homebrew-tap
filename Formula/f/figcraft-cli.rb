class FigcraftCli < Formula
  desc "Headless FigCraft design tool to inspect, export and script files, with MCP"
  homepage "https://getartcraft.com/apps/figcraft"
  url "https://github.com/storytold/figcraft/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e68cbccd4633765c6687664099c12fb356d38c722d60251792fa282497d3b61b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/figcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5d62b94ad8980b0389c63cb92522182e272fbd16189f165f89096e8709643b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f7ee4c0ad6982f4c5191bddf59530af190fe1eebd95936904ba1a8d3358d4e"
    sha256 cellar: :any,                 arm64_linux:   "a2a1b532056559e6c47415cd4abe0483f93efb15d81ce1a1826b2caa4e99a429"
    sha256 cellar: :any,                 x86_64_linux:  "c81947b689eebf3a0a8a89f5fc2461700dc4cae333e393225d9026b500a35cfe"
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
