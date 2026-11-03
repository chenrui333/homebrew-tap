class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "d88af51773f33d1b66b8bb4858a959e99cd1ad9a39d7b7e0728b873fff21262b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a14ceb6eee2ee81d9058a4493b98de93a1674833fd67089edec05579eca5c4e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1abc6536d37c65d9f86b3c9383835ec032fac2816dc793341c8cd822355e749f"
    sha256 cellar: :any,                 arm64_linux:   "004444534c1f3b04269f9f998cbb228981ec4e159a2d41af35338a2cbde5b6ae"
    sha256 cellar: :any,                 x86_64_linux:  "0eee9dd63e17f9b9e12f5955e591b0f924fc27f875cfb5516ff1419fced02a9f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/designcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/designcraft-cli --version")

    (testpath/"test.script").write <<~EOS
      frame.create {"rect": [72, 72, 300, 200], "content": "text", "text": "Homebrew"}
      story.get {"story": "$0.story"}
    EOS
    report = JSON.parse(shell_output("#{bin}/designcraft-cli script test.script " \
                                     "--save test.designcraft --export test.png"))
    assert_equal 2, report["completed"]
    assert_equal "Homebrew", report["results"][1]["text"]
    assert_equal "\x89PNG".b, (testpath/"test.png").binread(4)

    info = JSON.parse(shell_output("#{bin}/designcraft-cli run --in test.designcraft --cmd document.inspect"))
    assert_includes info["stories"].map { |story| story["preview"] }, "Homebrew"
  end
end
