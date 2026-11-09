class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "b67858d003db4cc3324bbafebf077b3ffa7314dc37fa4cffbd190876a7a0e4da"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74a69ec4f1e51bb062dffc47e606305e9d4f431b037176b42e539a068d84a2ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25423749eeb8097d60222adf9a78bac5a70c0d6e18b7c34591562166e4b8f382"
    sha256 cellar: :any,                 arm64_linux:   "a8f0449aa9293c2cff2f0c93acc09f8e14bca3206d1199d558f9a503854c2791"
    sha256 cellar: :any,                 x86_64_linux:  "d34455afb710956367713909260bd9b836379cdfe1fa292bf2b585ee5022c18c"
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
