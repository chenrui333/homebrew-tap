class Rustel < Formula
  desc "Terminal live coding studio for the Strudel music pattern language"
  homepage "https://github.com/tzfm/rustel"
  url "https://github.com/tzfm/rustel/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "c43eec341698db7d84d877d8134826eeb9becb82a4ee1b1b29287d7bc2ea7c24"
  license "AGPL-3.0-or-later"
  head "https://github.com/tzfm/rustel.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  on_intel do
    depends_on "nasm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"rustel", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustel --version")

    output = shell_output("#{bin}/rustel query -e 'note(\"c e\")' --end 1/1 --json")
    assert_equal %w[c e], JSON.parse(output).fetch("haps").map { |hap| hap.fetch("value").fetch("note") }
  end
end
