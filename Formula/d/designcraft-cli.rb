class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "0930eae534724266dc4930fe5e91dc598f9cd79d0e415e38ed9c47db1b035459"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d2e263d0eee72bd92f446000b93ff92dd89b0ef2d296a0fcfd7a960f686fda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b96265eef3df773578426db93dabf9549a200b721d8ca6a8385ff2f4c11e1d1a"
    sha256 cellar: :any,                 arm64_linux:   "895af0190e9bae6dc169d7054e17baf558f47b44db3ce8b378208029d369f33b"
    sha256 cellar: :any,                 x86_64_linux:  "d1bc1d709bd8dbc8f153fec76b8676e51903a96509bec62c8626c543d7fc1dda"
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
