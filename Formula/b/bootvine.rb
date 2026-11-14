class Bootvine < Formula
  desc "Live tree of systemd boot and shutdown jobs on the console"
  homepage "https://codeberg.org/wvhulle/bootvine"
  url "https://codeberg.org/wvhulle/bootvine/archive/v0.1.4.tar.gz"
  sha256 "2d28371e38fc09e9755ac1f688abcd19fa72795a90fac28b5ceca5f6216d6575"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/wvhulle/bootvine.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "f953d27f2482096699baad1b0a55e8ec38f8fc55e8d6ba1b3b754dd0213e40ab"
    sha256 cellar: :any, x86_64_linux: "557e5b7d932bd015d721820ff76a67f70b29c7d5c370bf6c843e8090a930ace6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "dbus"
  depends_on :linux
  depends_on "systemd"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bootvine")
    pkgshare.install "bootvine/system-files"
    doc.install "docs/install.md", "docs/configuration.md", "docs/guide.md"
  end

  def caveats
    <<~EOS
      The boot console requires systemd >= 246 as PID 1 and a virtual terminal.
      Homebrew does not install or enable boot services or initramfs hooks.
      Upstream unit and hook templates are in:
        #{pkgshare}/system-files
      Review the installation guide before opting into system integration:
        #{doc}/install.md
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bootvine --version")

    config = testpath/"bootvine.toml"
    config.write shell_output("#{bin}/bootvine defaults")
    system bin/"bootvine", "check", config

    config = testpath/"invalid.toml"
    config.write "[timing]\nkeep-final-frame-for = \"soon\"\n"
    output = shell_output("#{bin}/bootvine check #{config} 2>&1", 1)
    assert_match "invalid:", output
  end
end
