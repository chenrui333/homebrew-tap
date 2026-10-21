class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "92e2b9791b4402d853f115ccbf5ac03136f513493ccc4010a40b470ea1887652"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c938245e40db944f2f0b5dc5e0f614517279fced4396201493d047d1eb53f1b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9764e991d13f1b29dc0241dab2407f24aa68a366f290eb5e6e66cca903ba1637"
    sha256 cellar: :any,                 arm64_linux:   "a0a4e335f54f8d0cdf02e533bca5270cac40830bac519640a318092e4515a3f2"
    sha256 cellar: :any,                 x86_64_linux:  "fbc8447d5d55a4906fa3de85f4aefd7d47b371da7b64c235f1b70d505c7abea9"
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
