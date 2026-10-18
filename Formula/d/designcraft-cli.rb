class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e47b926827dd6c8db2dc7d2af7914fa270d5d5ef05896f80ecee442d9e391ea8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

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
