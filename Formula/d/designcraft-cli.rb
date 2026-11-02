class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "574e2899f09e7b82e226b37d51604df663ed01e75a47c394fc1ddfcfd5c83d1f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3229e9fd650890f0760d4aef51459d32e71628adb84cccb7dad90ca0001c788f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca2c262ad0921991e0f2901c2db7567d06a80be71d72e615a0bf89ac1a047a69"
    sha256 cellar: :any,                 arm64_linux:   "e5fc2a149b081ff9b7fbb9b2f5d2588411a571f3c5f23454469e13c5c97532cf"
    sha256 cellar: :any,                 x86_64_linux:  "79bdcb6224bd58b6a3d8319880837f61a0f1e96efa7a229edb5752435b416e63"
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
