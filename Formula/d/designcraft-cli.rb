class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "b990dcc761c1324dcc9bbd964eec152535e2e2ffb64879958b0acf4c81064326"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ac7dd2951fd431aafe3674e87b4e977001d1934b07bfc2eb6bf0f960dc3be1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4028a78247be17fa2047dff0dbf4a2376ff10ae9dd93a6e5e75178f53259356b"
    sha256 cellar: :any,                 arm64_linux:   "491630f661d62726b5e01e87bcd3a621c76e7c2481af768226947c6d92f18053"
    sha256 cellar: :any,                 x86_64_linux:  "c502652dcb4d94b0d0d0f69a061be31a3c618378f115353b77e5d234c1e3454d"
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
