class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "58d5af769ce5b9aa935e4b2df2347bb1a593b81e76ab2f4ff2f55b4994d6a408"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccf4fa7ecd62e92988daeaf42e4c370a46e75b6a1270cade512cc142f0c37a1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d058a57191c976380482934439ebcddd7d633b9fa7333265c9329f71e59e6b89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec11815dcd1ea292e62499c24aa09334c7158f9d7d6cf0c3bf5b83431391c859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "937d59e42fff1489614bf328c443e39d3f9ee9216199f4bc0573158cbe3771d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85939bd0a62277532c510dd400f50b4f60a4a1680d5eb956777d658077a3d74b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ccboard")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccboard --version")

    claude_home = testpath/".claude"
    claude_home.mkpath
    ENV["CCBOARD_CLAUDE_HOME"] = claude_home

    output = shell_output("#{bin}/ccboard stats")
    assert_match "Sessions indexed:", output
  end
end
