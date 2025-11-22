class OpensnitchTui < Formula
  desc "TUI for OpenSnitch"
  homepage "https://github.com/amalbansode/opensnitch-tui"
  url "https://github.com/amalbansode/opensnitch-tui/archive/ae25dc68fe30d6ae5fdf89162c29653ef9947e4f.tar.gz"
  version "0.0.1"
  sha256 "0bf7c9ce5651dee93ff2022d0f046adca03d08717fec3f8803d184f33e54e8e0"
  license "GPL-3.0-only"
  head "https://github.com/amalbansode/opensnitch-tui.git", branch: "main"

  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # opensnitch-tui is a TUI application
    assert_match version.to_s, shell_output("#{bin}/opensnitch-tui --version")
  end
end
