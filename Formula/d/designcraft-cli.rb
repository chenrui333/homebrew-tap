class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "d1baa1292ff2543ae7ce66fe80c63d45908e95e98b46f2915522d4a9d312b873"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138ac2a27257eb241163d4afe7443b999fe63fee2625d340395396ff050460a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0e82b66ad0e4819fab57608db538c8b4fb38019eadfc394e2d762c3b781c507"
    sha256 cellar: :any,                 arm64_linux:   "ec0e8a494b6b9e1b94c8dd3922fb781711867d026707ed6d6bafce9c5ccbc9db"
    sha256 cellar: :any,                 x86_64_linux:  "20544bb46a36ef0899f6bbd9a6c62ec06f1f4729d2763ce4746f507007fe6da6"
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
