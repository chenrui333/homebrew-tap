class Ztl < Formula
  desc "Terminal tool for visually comparing time zones"
  homepage "https://github.com/findyourexit/zonetimeline-tui"
  url "https://github.com/findyourexit/zonetimeline-tui/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "60171d6eb5aeabaa3d9470f7cb2efef7ddcd258ac417185812a9f35697877a35"
  license "MIT"
  head "https://github.com/findyourexit/zonetimeline-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc9cdb19a8970cbcef2d43e106452ec9efad69c925cca0afb75cbe36cf05127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29db94c7fcb41221d862ed04a9dbafa7a1a461aa26a6908bf4dec74bd14d3568"
    sha256 cellar: :any,                 arm64_linux:   "589ed5a0540385609cc417098a209066026dfc0b3219fc6d339cf21642f59a8a"
    sha256 cellar: :any,                 x86_64_linux:  "be2f45f2b56d1bb25ae89ebae75d327530752dc253da73e6941d1c005aff9784"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ztl --version")

    # Fixed offsets avoid dependence on the current UTC date or daylight saving time.
    output = shell_output("#{bin}/ztl --plain --zones UTC+5:30,UTC-4 --time 07:30 --nhours 4")
    assert_match(/^UTC\+5:30:\s+\d{4}-\d{2}-\d{2} 13:00:00$/, output)
    assert_match(/^UTC-4:\s+\d{4}-\d{2}-\d{2} 03:30:00$/, output)

    output = shell_output("#{bin}/ztl --plain --zone Mars/Olympus 2>&1", 1)
    assert_match "unknown timezone: Mars/Olympus", output
  end
end
