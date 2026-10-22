class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "0654543b8407b3229544235ced0a2ee0bea6f420c899ae10be08b51a9b3c8112"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f0cb9c2ce540aa86da6560433c217dc969ede1d2e92ab71c0654dd2947d15b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b7cb8aba3df71de843bf007a4b9be5b0486aea73ff8cbb72b0d8dda43368aa6"
    sha256 cellar: :any,                 arm64_linux:   "8a990551f86acbd92fd28a64fcb29d86b16a4ab67d307f42ebee59f4e55caf94"
    sha256 cellar: :any,                 x86_64_linux:  "0c0a587c3ba9fc1472a1ecd353a40ded96f28b1f2b3cffe0dd9f45ce56dc0bc7"
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
