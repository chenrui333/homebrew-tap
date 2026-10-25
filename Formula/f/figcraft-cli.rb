class FigcraftCli < Formula
  desc "Headless FigCraft design tool to inspect, export and script files, with MCP"
  homepage "https://getartcraft.com/apps/figcraft"
  url "https://github.com/storytold/figcraft/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "fac45400fd7a6596adf5a612baf7af9b87a8874f24a191af1f9eda15401d0462"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/figcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46535a6ab195a746e5f4c07b7546e783327ebd7e05fa6be883d35c3e7d8638fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ebd5bdb93d32c59e6fc51628c66a4ee06cc7b142e7262dac51f24cfbf9d3e94"
    sha256 cellar: :any,                 arm64_linux:   "e4386c4531b02ac9c62f8872ba4d0cfca7bceebb242b940c61d7a355e57c8115"
    sha256 cellar: :any,                 x86_64_linux:  "162235a117a7e60405b13a576f7a1d88c2d2fca708b4ac78c999a0ed3bb43b2f"
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
