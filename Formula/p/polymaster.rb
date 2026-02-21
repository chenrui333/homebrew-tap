class Polymaster < Formula
  desc "Monitor large transactions on Polymarket and Kalshi prediction markets"
  homepage "https://github.com/neur0map/polymaster"
  url "https://github.com/neur0map/polymaster/archive/95277b34c66eaa307d169cec45320ffa9f2403a0.tar.gz"
  version "0.2.0"
  sha256 "235e3078ee8a9a348d9d75389e7c6f5837c0f4dbd6b748c03b3c9b49b88f8fa7"
  license :cannot_represent
  head "https://github.com/neur0map/polymaster.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    ENV["HOME"] = testpath

    assert_match "Usage:", shell_output("#{bin}/wwatcher --help")
    assert_match "WHALE WATCHER STATUS", shell_output("#{bin}/wwatcher status")
  end
end
