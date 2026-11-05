class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "77a1ad63f00deaa2bce92ee4399af763c7344806d20e4f6ff07e9b51cb491330"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91a14e345ed940f86ca2c65797caa08db56f4178b1219360476119abc3db4a36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2ef366c6e267003d858197b638e84fcb1715c3360fe58c3b183f9817b3cbd02"
    sha256 cellar: :any,                 arm64_linux:   "8899dc4179adc45c44a8d829d87f50a9eb360eb52a4ec64e7c553527bc4425be"
    sha256 cellar: :any,                 x86_64_linux:  "0367ea0f94e6a308f61cb03b615d820a573a7b6d43655b7c37468859f37409bd"
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
