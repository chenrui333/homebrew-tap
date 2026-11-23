class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "e106fde2015783c69ad420ea9a3e5a1e33fa10d7261430a3515ed3a4021ccdac"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e61b60a67c9f7262ef758bfeca1d135aca632b98938c0fd162b1ced1507b0d5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fe8ae08cf08d8c7dfb6088b6ac8fb6fa2c3141c79ea2d7d24280b232fe78c95"
    sha256 cellar: :any,                 arm64_linux:   "8b63ec40c3822bd964a48cc6f742f714afd87d9a10dd6f20a378334d458dd642"
    sha256 cellar: :any,                 x86_64_linux:  "47d95b8a2e373d4f7c1cdf14d83af0b694ce1c636ae4db84acf8dc5b6afdc4fe"
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
