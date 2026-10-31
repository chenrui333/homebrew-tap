class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "d1baa1292ff2543ae7ce66fe80c63d45908e95e98b46f2915522d4a9d312b873"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "123a329e4e89e7f170ed2edeb2425af185b4314aaa5e122fc9475fdc6f101874"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f3bd40ba392311aebcfa023f3bd2277bd31a14a1b33d5a13ec021d1d351660"
    sha256 cellar: :any,                 arm64_linux:   "e174f7564e58936e411e1b2afbff5a94f726599d52a4b311f12248fbe9f52e51"
    sha256 cellar: :any,                 x86_64_linux:  "d7879dc12c8bd9929ff097c7b021d5934d65f1f1baac85ee1890fe8cd93d1097"
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
