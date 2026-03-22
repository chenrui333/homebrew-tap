class TuiBanner < Formula
  desc "Cinematic ANSI banners for Rust CLI/TUI"
  homepage "https://github.com/coolbeevip/tui-banner"
  url "https://github.com/coolbeevip/tui-banner/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "7a324196d9b68a9354a0ca25113f375cbf550e3024aea8bb7bf2538975d6214f"
  license "Apache-2.0"
  head "https://github.com/coolbeevip/tui-banner.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b656c79961764b58b9675078d818e037eee3a37f7c323a262850f123cc91bbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bf706bc603b3a262e929d8685fc223376f4f6b1468356c46df519171a1945ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "184591f320aed2548bfe45642a40f8d8129ea645af8ace516b7788d4dcff9289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e5432c4ef268db85922b98c175800c29366f424bfb9eb206bae389c51e90f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "261d7f78b38f19d6a1fdf997f4a96244636d2a259f5ad8b6d42a8e3476b18fff"
  end

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
