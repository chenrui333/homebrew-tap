class Rustel < Formula
  desc "Terminal live coding studio for the Strudel music pattern language"
  homepage "https://github.com/tzfm/rustel"
  url "https://github.com/tzfm/rustel/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "7081abf4f6547f8863b11bec156278ebbab961129d44477f253727e4baad2bb6"
  license "AGPL-3.0-or-later"
  head "https://github.com/tzfm/rustel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "f2f021fc7f08f4d1ab91879b26146a4f202ac680f53bdb044ec0225565e67d44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d9ef2fa5d53c08231b61773013240dd74a378b3120ca196aa812266fed996f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b1a9de2049b2593ca116ac09c6548593ef58ba5c9fbb6e95b867352d7bb358e"
    sha256 cellar: :any,                 arm64_linux:   "3b18da88739e99044b25c615cc80e09cca5e3739a608fbb78ce631069b15364b"
    sha256 cellar: :any,                 x86_64_linux:  "603d0425f3b176fd937a97ba034cb1eec0a435506e4ee33fad75ab0d652e1d35"
  end

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
