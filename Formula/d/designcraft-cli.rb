class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "eecda956093fe89d1511eb88112a4cf88d62354b652338d8e9dccc28690d62c0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7739ddf24fec2ce599e654d39fc1aaf0410e9d7509ea19f8a4cb8cb9f0e21065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a43aff35d17b04d90f2716a89423b0180899b2743d58e961d8cc5bc9cbd3888"
    sha256 cellar: :any,                 arm64_linux:   "2dd929c83756c4eed4acc1cc52b41494177ee071c5746ea35fa3ca0b4982c741"
    sha256 cellar: :any,                 x86_64_linux:  "151523a597b99ab345d0b738f5edbdd7a573c622dd96d7537c5735ffd0476e48"
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
