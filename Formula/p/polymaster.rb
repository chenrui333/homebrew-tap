class Polymaster < Formula
  desc "Monitor large transactions on Polymarket and Kalshi prediction markets"
  homepage "https://github.com/neur0map/polymaster"
  url "https://github.com/neur0map/polymaster/archive/95277b34c66eaa307d169cec45320ffa9f2403a0.tar.gz"
  version "0.2.0"
  sha256 "235e3078ee8a9a348d9d75389e7c6f5837c0f4dbd6b748c03b3c9b49b88f8fa7"
  license :cannot_represent
  head "https://github.com/neur0map/polymaster.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33f4eb245c555e99838aff0eca8d74abfd8fc7166119fd2cea512a99c7737d60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b6c11521812012f5acba0ddb6dc90836a7f4bf53c34283c0ffc87f4c51a117"
    sha256 cellar: :any,                 arm64_linux:   "a43149cd4b932ec319cac0f4afc2e96d3fe1a466cf74706be7629b90e9a10760"
    sha256 cellar: :any,                 x86_64_linux:  "b06fe6ba7d6884ea56f1e8e1bcbe76b63207525829b5045da6ea3ff38eb288e2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_match "WHALE WATCHER STATUS", shell_output("#{bin}/wwatcher status")
  end
end
