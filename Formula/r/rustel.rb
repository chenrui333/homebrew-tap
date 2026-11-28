class Rustel < Formula
  desc "Terminal live coding studio for the Strudel music pattern language"
  homepage "https://github.com/tzfm/rustel"
  url "https://github.com/tzfm/rustel/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "7081abf4f6547f8863b11bec156278ebbab961129d44477f253727e4baad2bb6"
  license "AGPL-3.0-or-later"
  head "https://github.com/tzfm/rustel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e998ce1be7a0470d2d0b3f5074de2956e674bb11878305688040086181cdbb02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "160184b081e45e8233437247ec0a9ab0c55d3a3f4f188489a5c13fa9768017ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4b12bc25471270109e9c41f2f2ec4c05a0287a6bcd8c2f3ea41d5aeabb3be88"
    sha256 cellar: :any,                 arm64_linux:   "62d3b5faf499aa9298284c34b23d44519c1f11f81d51cbe1211445c0c6acd2af"
    sha256 cellar: :any,                 x86_64_linux:  "c6baf7e0061a817dafc8812d7ecb74ecc28d3369a19b04a604e2ef376d446620"
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
