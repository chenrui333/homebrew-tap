class ChessTui < Formula
  desc "Play chess from your terminal"
  homepage "https://github.com/thomas-mauran/chess-tui"
  url "https://github.com/thomas-mauran/chess-tui/archive/refs/tags/2.9.0.tar.gz"
  sha256 "6ffe4c1b7177ed3a546c0b1b82f22f595c16de3989404e49041aacf7624a7584"
  license "MIT"
  head "https://github.com/thomas-mauran/chess-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "188cb7afacd0ddb323832ae7e7007cab7146e17547fad5c77f3a459cb2860b96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f175459a4fba7bb91145285b810d4eb217387f946132feae2c12e32283eb36c"
    sha256 cellar: :any,                 arm64_linux:   "6ce2529c3cbf4e2feae55b07f975ade1b6123ebea900bba2953d0d22a4ddee08"
    sha256 cellar: :any,                 x86_64_linux:  "80cc5ecabb7bb793cf90cdf2240a2293fef79e2ecff74e1d3a12dd18a7120970"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chess-tui --version")

    output = shell_output("#{bin}/chess-tui --update-skins")
    assert_match "Created skins.json with default content", output

    config_root = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end
    assert_path_exists config_root/"chess-tui/skins.json"
  end
end
