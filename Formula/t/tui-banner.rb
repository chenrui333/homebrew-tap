class TuiBanner < Formula
  desc "Cinematic ANSI banners for Rust CLI/TUI"
  homepage "https://github.com/coolbeevip/tui-banner"
  url "https://github.com/coolbeevip/tui-banner/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "20154caf8c9f621a2e51183fad2315f09e6b146937a1d7699f15b0d7cbcc4b69"
  license "Apache-2.0"
  head "https://github.com/coolbeevip/tui-banner.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7708b53ddf635abc9a047cf8b53c97e439c3168a9c5acc13388e7bb100c566c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd5d3afce4d5b69f48bdd01424203920ba5b2b857763d9994638da458af35a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4a83a56ee315fabc4d34709d69a71f7f07e0c07f924e21cdedc2e8059288264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c4c01a5167d211235fb1bc993f7a96f6b51638a771e247cec8684e983ff7f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b193b1304796b1f584a80b4440b02cd203c4a492e6c58c481a01cacf132772bf"
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
