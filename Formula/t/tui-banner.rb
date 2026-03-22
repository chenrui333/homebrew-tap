class TuiBanner < Formula
  desc "Cinematic ANSI banners for Rust CLI/TUI"
  homepage "https://github.com/coolbeevip/tui-banner"
  url "https://github.com/coolbeevip/tui-banner/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "7a324196d9b68a9354a0ca25113f375cbf550e3024aea8bb7bf2538975d6214f"
  license "Apache-2.0"
  head "https://github.com/coolbeevip/tui-banner.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "tui-banner-cli")
  end

  test do
    output = shell_output("#{bin}/tui-banner --text HI --color-mode none")
    assert_operator output.lines.count, :>, 2
    assert_match "█", output
    refute_match "\e[", output
  end
end
