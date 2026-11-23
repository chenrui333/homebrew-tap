class Bootvine < Formula
  desc "Live tree of systemd boot and shutdown jobs on the console"
  homepage "https://codeberg.org/wvhulle/bootvine"
  url "https://codeberg.org/wvhulle/bootvine/archive/v0.1.5.tar.gz"
  sha256 "7f6caf1ca56bf6ea25be74197c6723da49cfa3c9af365372022371ac40bffcad"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/wvhulle/bootvine.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "362bf81dd636b8bc9cc327287603e5b027373ab34f7c4c621b4a026fd526a32f"
    sha256 cellar: :any, arm64_linux:  "98cfcf4532cd318fd444acc4f29266ed3bd329e55eb2f56840b7888e58a57b54"
    sha256 cellar: :any, x86_64_linux: "49e74da3bdcbd18c0e1445c8598612de54e1ef29875f7a8dcfab5af0e8976347"
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
