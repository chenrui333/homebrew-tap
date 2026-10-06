class OpensnitchTui < Formula
  desc "TUI for OpenSnitch"
  homepage "https://github.com/amalbansode/opensnitch-tui"
  url "https://github.com/amalbansode/opensnitch-tui/archive/ae25dc68fe30d6ae5fdf89162c29653ef9947e4f.tar.gz"
  version "0.0.1"
  sha256 "0bf7c9ce5651dee93ff2022d0f046adca03d08717fec3f8803d184f33e54e8e0"
  license "GPL-3.0-only"
  head "https://github.com/amalbansode/opensnitch-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "94c8c965e24af22fc9f6fd9489500774661dde79d542c48e199116bbefd6ac32"
    sha256 cellar: :any, x86_64_linux: "936a5de80749ab4dbff2af9385bd7d0e554e9cf2a9b8cef504c962f2c8961ace"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # opensnitch-tui is a TUI application
    assert_match version.to_s, shell_output("#{bin}/opensnitch-tui --version")
  end
end
