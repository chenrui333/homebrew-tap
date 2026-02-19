class Wiremix < Formula
  desc "TUI audio mixer for PipeWire"
  homepage "https://github.com/tsowell/wiremix"
  url "https://github.com/tsowell/wiremix/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "9fd8979fa3bc260a80d170c30041ab2aeea26273439bac8ce928a9405ce1d0f5"
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
