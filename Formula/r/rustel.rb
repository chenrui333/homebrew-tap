class Rustel < Formula
  desc "Terminal live coding studio for the Strudel music pattern language"
  homepage "https://github.com/tzfm/rustel"
  url "https://github.com/tzfm/rustel/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "8df2e65cd47df5bcba34993aafbaed724263259acae6d295f9abf7581b7f4274"
  license "AGPL-3.0-or-later"
  head "https://github.com/tzfm/rustel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "2e2aad6fca1af4075b4f2a9d0030552324e2522637c5cd21e07b1a5bfc3e7717"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9a62d38f968417e714fefb63f9a168aa03e5fec2c69d3f34b9c270282922a20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07af403a7baaf9bf506f775d18c5c6fb9982da65d70ff12a454e0281f691e45b"
    sha256 cellar: :any,                 arm64_linux:   "8431702d7906cbe887f25de46327df41031167819e98c024a693e865ed5085f1"
    sha256 cellar: :any,                 x86_64_linux:  "ced91a7762c6c1c337b755c5156241816a5e21d1548bb1b7939d69ccba8f92b7"
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
