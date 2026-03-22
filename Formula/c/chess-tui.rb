class ChessTui < Formula
  desc "Play chess from your terminal"
  homepage "https://github.com/thomas-mauran/chess-tui"
  url "https://github.com/thomas-mauran/chess-tui/archive/refs/tags/2.5.1.tar.gz"
  sha256 "65054f32c6361dc859306504046968a1be776d91658d0fec018035be398d9002"
  license "MIT"
  head "https://github.com/thomas-mauran/chess-tui.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
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
