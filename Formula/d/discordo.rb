class Discordo < Formula
  desc "Lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  url "https://github.com/ayn2op/discordo/archive/77f21369b4d258eaec590d8f1353b6812683829e.tar.gz"
  version "unstable-2026-04-13"
  sha256 "69751db8d3bec788ad76c8da01675315fad8201d3601fbb39349c1c3b4f266b3"
  license "GPL-3.0-only"

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # discordo is a TUI app, so just verify the binary runs
    assert_match "config-path", shell_output("#{bin}/discordo --help 2>&1")
  end
end
