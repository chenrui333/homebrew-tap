class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "3d46425c9656f829a25d5b0001f4fb22f80953b2c70979db68048ec92a3c364a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c44e67d1ab6a513037481d309920dd3af9784865b80807282ae15b4d612102e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a1b15b3fb4b13fe474ac15d4c44ac34980707eb25ad0e7762ff5f6b05687fc6"
    sha256 cellar: :any,                 arm64_linux:   "8df7bb3ad828e20f97138ae7ec2c16b09c769280be503aa8f3d709c5e81cbabe"
    sha256 cellar: :any,                 x86_64_linux:  "13dc0550ab8b0d4e6735bb14c4605b7b8d5bcf4029e21752ee9e8ec9495ff785"
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
