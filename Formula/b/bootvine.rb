class Bootvine < Formula
  desc "Live tree of systemd boot and shutdown jobs on the console"
  homepage "https://codeberg.org/wvhulle/bootvine"
  url "https://codeberg.org/wvhulle/bootvine/archive/v0.1.3.tar.gz"
  sha256 "89d53d937f818ec80b54c9f9d8c501f7254f8b776e549543bb39a87da264ca0b"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/wvhulle/bootvine.git", branch: "main"

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
