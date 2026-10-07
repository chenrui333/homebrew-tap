class TuiBanner < Formula
  desc "Cinematic ANSI banners for Rust CLI/TUI"
  homepage "https://github.com/coolbeevip/tui-banner"
  url "https://github.com/coolbeevip/tui-banner/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "20154caf8c9f621a2e51183fad2315f09e6b146937a1d7699f15b0d7cbcc4b69"
  license "Apache-2.0"
  head "https://github.com/coolbeevip/tui-banner.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07eab0e56e8bc3dda1fadf0afed53c1bf3d9570dad0337757e0369997fb75a1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f9951460bebb308a2421a73f939be22108faa227fd53c2ccffb9f8de10cc67d"
    sha256 cellar: :any,                 arm64_linux:   "82bba4c63d1fe7b4e0906be8e876c4a0f788af8719017dea1d6709b902c2b160"
    sha256 cellar: :any,                 x86_64_linux:  "cbfb9bb3cd24e6d4ebf9316cafea0c4cc2f92bef01c61943a186df8fd9948a7f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
