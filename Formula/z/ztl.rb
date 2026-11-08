class Ztl < Formula
  desc "Terminal tool for visually comparing time zones"
  homepage "https://github.com/findyourexit/zonetimeline-tui"
  url "https://github.com/findyourexit/zonetimeline-tui/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "60171d6eb5aeabaa3d9470f7cb2efef7ddcd258ac417185812a9f35697877a35"
  license "MIT"
  head "https://github.com/findyourexit/zonetimeline-tui.git", branch: "main"

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
