class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e47b926827dd6c8db2dc7d2af7914fa270d5d5ef05896f80ecee442d9e391ea8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8004a7ede553e62cb403583f8fdb9310801e1674e5046d9c76f683c62b574656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "187f646e47a2c579ce6f3b37445be3ef562a5508e24bf99611312ebf9d93d3db"
    sha256 cellar: :any,                 arm64_linux:   "c0d016091497c1dc19fd8d41f82cfa963b0cd3ec29ae6b354aaff2cd175833e8"
    sha256 cellar: :any,                 x86_64_linux:  "611b9e6e0342a979ae9882b9c9ea9c777175422b763f1e018ca43555307b1faa"
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
