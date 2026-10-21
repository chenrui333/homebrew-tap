class ChessTui < Formula
  desc "Play chess from your terminal"
  homepage "https://github.com/thomas-mauran/chess-tui"
  url "https://github.com/thomas-mauran/chess-tui/archive/refs/tags/2.8.0.tar.gz"
  sha256 "29c49dbc8fd69b7dc65ddd3006123b8bf05c223629ec7f6c4110ca6992cb0d4b"
  license "MIT"
  head "https://github.com/thomas-mauran/chess-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6882c252728e40f592f1d52603ac906ce1b18d4e771a704918abdb6604ddf51f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dea23ffc93f12467cc2de58692ab0909fb3eb23556c6c3c47cd5d3f86b09df8b"
    sha256 cellar: :any,                 arm64_linux:   "02d1edb881f862299f164061dc5585287ff02f0a00c351b95f9723795eba871b"
    sha256 cellar: :any,                 x86_64_linux:  "d76d39d397824af1a5b64ebe4623452ac4c378eae35fa3ca495121be66ed13f9"
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
