class Wiremix < Formula
  desc "TUI audio mixer for PipeWire"
  homepage "https://github.com/tsowell/wiremix"
  url "https://github.com/tsowell/wiremix/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "db357d21c76809d674024f1094c2ac6ddd2d6866d4b8ae53cbb0620599006e31"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tsowell/wiremix.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "pipewire"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wiremix #{version}", shell_output("#{bin}/wiremix --version")
  end
end
