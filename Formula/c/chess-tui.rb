class ChessTui < Formula
  desc "Play chess from your terminal"
  homepage "https://github.com/thomas-mauran/chess-tui"
  url "https://github.com/thomas-mauran/chess-tui/archive/refs/tags/2.7.1.tar.gz"
  sha256 "471b6280c8aa0979956b85d54dfd216855a47f8517a9a1d3e5286e4044adaac5"
  license "MIT"
  head "https://github.com/thomas-mauran/chess-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b73aea38b9f2d238eb57a3c7b874ee482ad55666f0638d17181e73ee34c4aae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3957d29e60309236e4fdeff64af2a8a4aeefb9861ec5efb263ebe21be646311f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e34be12842479a0cac6e07ea5c94e48a2f815220a9be174a91399b8c7e7c1a4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4c6437b6179d554a3c4769b2940468f26e04b2c3f3b260b3921df94a9ada108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7044d23fbf319f6ea14b7d6197ead9afce38f48dd89e543c735c1be9ccf22b"
  end

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
